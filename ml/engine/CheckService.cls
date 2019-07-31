/// Service constantly valides model quality and if error rate exceeds Threshold retrains the model.
Class ml.engine.CheckService Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Property Adapter As Ens.InboundAdapter;

/// Percent of errors after which we need to retrain the model
Property Threshold As %Integer(MAXVAL = 100, MINVAL = 1) [ InitialExpression = 20 ];

/// Number of rows used to retrain the model
Property RowCount As %Integer(MINVAL = 100) [ InitialExpression = 1000 ];

Parameter SETTINGS = "Threshold:ML,RowCount:ML";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	#dim sc As %Status = $$$OK
	&sql(SELECT TOP 1 1 FROM ml_engine.Data WHERE prediction is not null)
	if (SQLCODE=100) {
		$$$TRACE("No predictions")
		quit sc
	}
	
	&sql(SELECT max(id) INTO :maxId FROM ml_engine.Data WHERE prediction is not null)
	if (SQLCODE'=0) {
		set sc = $$$ERROR($$$SQLError, SQLCODE, $g(%msg))
		quit sc
	}
	
	if maxId > ..RowCount {
		set minId = maxId - ..RowCount
	} else {
		set minId = 1
	}
	
	&sql(SELECT count(1)\10 into :errors FROM ml_engine.Data WHERE diff<>0 AND ID BETWEEN :minId AND :maxId)
	if (SQLCODE'=0) {
		set sc = $$$ERROR($$$SQLError, SQLCODE, $g(%msg))
		quit sc
	}
	
	set sc = ##class(ml.engine.CheckData).Add(errors, ..Threshold, minId, maxId)
	
	if errors>..Threshold {
		$$$TRACE($$$FormatText("Model error percentage: %1 exceeds threshold %2", errors, ..Threshold))
	
		set trainReq = ##class(ml.engine.TrainRequest).%New()
		set trainReq.EndId = maxId
		set trainReq.StartId = minId
		
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

