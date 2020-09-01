Class ml.cam.rest.Main Extends %CSP.REST
{

XData UrlMap
{
<Routes>
   <Route Url="/photo/:id" Method="GET" Call="Photo"/>
   <Route Url="/imgUpload" Method="POST" Call="PhotoUpload"/>
</Routes>
}

ClassMethod Photo(photoId As %Integer) As %Status
{
	set exists = ##class(ml.cam.data.Photo).%ExistsId(photoId)
	quit:'exists $$$ERROR($$$GeneralError, $$$FormatText("Photo with id %1 does not exist", photoId))
	
	set stream = ##class(%Stream.FileBinary).%OpenId(##class(ml.cam.data.Photo).DataGetStored(photoId))
	
	#dim sc As %Status = $$$OK
    #dim %response As %CSP.Response
	kill %request.Data
	set %request.Data("STREAMOID",1)= ##class(%CSP.StreamServer).Encrypt(stream.%Oid())
	if ##class(%CSP.StreamServer).OnPreHTTP() {
		set %response.ContentType = "image"
		set sc = ##class(%CSP.StreamServer).OnPage()
	}

	quit sc
}

ClassMethod PhotoUpload() As %Status
{
	#dim %request As %CSP.Request	
	#dim stream As %CSP.BinaryStream
	set stream = %request.GetMimeData("file")
	
	set ext = $ZCVT($select(stream.FileName[".":$piece(stream.FileName,".",*),1:""),"l")
	set file = ##class(%File).TempFilename(ext)
	set fileStream = ##class(%Stream.FileBinary).%New()
	do fileStream.LinkToFile(file)
	set sc = fileStream.CopyFromAndSave(stream)
	quit:$$$ISERR(sc) sc
	
	set photo = ##class(ml.cam.data.Photo).%New()
	set photo.Data = fileStream
	set sc = photo.%Save()
	quit:$$$ISERR(sc) sc
	
	set timeout = 60
	set processName = "ml.cam.ens.bp.MatcherProcess"
	set serviceName = "EnsLib.Testing.Service"
	
	set req = ##class(ml.cam.ens.msg.MatchesRequest).%New()
	
	set req.Target = photo
	set req.IdVariable = "imagesIds"
	
	set sc = ..InvoceHostSync(processName, req, .resp, timeout, serviceName)
	quit:$$$ISERR(sc) sc
	quit:'$isObject(resp) $$$ERROR($$$GeneralError, "Timeout")
	
	#dim resp As ml.cam.ens.msg.MatchesResponse
	
	set distance = ""
	set httpResp = {}
	for {
		set photoMatch = resp.Matches.GetNext(.distance)
		quit:distance=""
		
		do httpResp.%Set("image" _ ($i(i)-1), "/cam/photo/" _ photoMatch.%Id())
	}
	set %response.ContentType = ..#CONTENTTYPEJSON
	write httpResp.%ToJSON()
	
	quit sc
}

ClassMethod InvoceHostSync(targetHostName As %String, request As %Persistent, Output response As %Persistent, timeout As %Integer, serviceName As %String = "EnsLib.Testing.Service")
{
	#dim sc As %Status
		
	#dim service As Ens.BusinessService
	set sc = ##class(Ens.Director).CreateBusinessService(serviceName, .service)
	quit:$$$ISERR(sc) sc
	set sc = service.SendRequestSync(targetHostName, request, .response, timeout)
	
	quit sc
}

/// Issue an "304 Not Modified" status
ClassMethod Http304() As %Status
{
    set %response.Status="304 Not Modified"
    quit $$$OK
}

}

