Class ml.cam.utils.ProdTest
{

/// w $System.Status.GetErrorText(##class(ml.cam.utils.ProdTest).LoadPhotos())
ClassMethod LoadPhotos(startId = 7839, endId = 20670)
{
	set target = "ml.cam.ens.bp.LoaderProcess"
	set req = ##class(ml.cam.ens.msg.LoaderRequest).%New()
	
	set req.Variable = "features"
	set req.IdVariable = "imagesIds"
	
	set ids = ""
	for id=startId:1:endId {
		set ids = ids _ $lb(id)
	}
	
	set req.PhotoIds = $lts(ids)
	
	set sc = ##class(isc.util.EnsUtils).invokeHostAsync(target, req)
	
	quit sc
}

/// w $System.Status.GetErrorText(##class(ml.cam.utils.ProdTest).MatchPhoto())
ClassMethod MatchPhoto(id = 57865)
{
	set target = "ml.cam.ens.bp.MatcherProcess"
	set req = ##class(ml.cam.ens.msg.MatchesRequest).%New()
	
	set req.Target = ##class(ml.cam.data.Photo).%OpenId(id)
	set req.IdVariable = "imagesIds"
	
	set sc = ##class(isc.util.EnsUtils).invokeHostAsync(target, req)
	
	quit sc
}

}

