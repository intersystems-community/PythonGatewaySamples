Class ml.engine.CheckService Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Property Adapter As Ens.InboundAdapter;

/// Percent of errors after which we need to retrain the model
Property Threshold As %Integer(MAXVAL = 100, MINVAL = 1) [ InitialExpression = 20 ];

/// Number of rows used to retrain the model
Property RowCount As %Integer(MINVAL = 100) [ InitialExpression = 1000 ];

Parameter SETTINGS = "Threshold:Basic";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	#dim sc As %Status = $$$OK
	
	&sql(SELECT max(id) INTO :maxId FROM ml_engine.Data WHERE prediction is not null)
	if (SQLCODE'=0) {
		set sc = $$$ERROR($$$SQLError, SQLCODE, $g(%msg))
		quit sc
	}	
	
	&sql(SELECT count(1)\10 into :errors FROM ml_engine.Data WHERE diff<>0 AND ID BETWEEN :maxId-1000 AND :maxId)
	if (SQLCODE'=0) {
		set sc = $$$ERROR($$$SQLError, SQLCODE, $g(%msg))
		quit sc
	}
	
	if errors>..Threshold {
		$$$TRACE($$$FormatText("Model errors percent %1 exceed threshold %2", errors, ..Threshold))
	
		set trainReq = ##class(ml.engine.TrainRequest).%New()
		set trainReq.EndId = maxId
		
		if maxId > ..RowCount {
			set trainReq.StartId = maxId - ..RowCount
		} else {
			set trainReq.StartId = 1
		}
		
		#dim predResp As Ens.StringResponse
		set sc = ..SendRequestSync(##class(ml.engine.TrainProcess).%ClassName(1), trainReq, .predResp)
		if $$$ISOK(sc) {
			$$$TRACE($$$FormatText("Updated model on data from %1 to %2", trainReq.StartId, trainReq.EndId))
		}
	} else {
		$$$TRACE($$$FormatText("Model error percentage: %1 does not exceed threshold: %2", errors, ..Threshold))
	}
	

	quit sc
}

}

