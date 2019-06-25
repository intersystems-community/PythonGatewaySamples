/// Trains initial model
Class ml.engine.InitService Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Property Adapter As Ens.InboundAdapter;

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status [ CodeMode = expression ]
{
$$$OK
}

/// This user callback method is called via initConfig() from %OnNew() or in the case of SOAP Services from OnPreSOAP()
Method OnInit() As %Status
{
	$$$TRACE("INIT")
	set trainReq = ##class(ml.engine.TrainRequest).%New()
	set trainReq.EndId = 1000
	set trainReq.StartId = 1
	
	#dim predResp As Ens.StringResponse
	set sc = ..SendRequestAsync(##class(ml.engine.TrainProcess).%ClassName(1), trainReq)
	quit sc
}

}

