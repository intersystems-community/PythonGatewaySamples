/// Trains initial model
Class ml.cam.ens.bs.InitService Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Property Adapter As Ens.InboundAdapter;

Property IndexSize As %Integer [ InitialExpression = 1000 ];

Parameter SETTINGS = "IndexSize:ML";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status [ CodeMode = expression ]
{
$$$OK
}

/// This user callback method is called via initConfig() from %OnNew() or in the case of SOAP Services from OnPreSOAP()
Method OnInit() As %Status
{
	// We're inside the container. Let's wait a little.
	//hang:$system.Util.GetEnviron("ISC_PACKAGE_INSTALLDIR")="/usr/irissys" 60
	$$$TRACE("INIT")
	
	if $d(^ml.cam.data.PhotoD(1))=0 {
		set sc = ##class(ml.cam.data.Photo).LoadDir($system.Util.GetEnviron("PHOTO_DIR"))
		$$$TRACE("LOADED PHOTOS")
	}
	
	set req = ##class(ml.cam.ens.msg.LoaderRequest).%New()
	
	set req.Variable = "features"
	set req.IdVariable = "imagesIds"
	
	set ids = ""
	
	set maxId = $g(^ml.cam.data.PhotoD, 1)
	
	set:(..IndexSize>maxId) ..IndexSize = maxId
	
	for id=1:1:..IndexSize { 
		set ids = ids _ $lb(id)
	}
	set req.PhotoIds = $lts(ids)
	
	
	#dim predResp As Ens.StringResponse
	set sc = ..SendRequestAsync(##class(ml.cam.ens.bp.LoaderProcess).%ClassName(1), req)
	quit sc
}

}

