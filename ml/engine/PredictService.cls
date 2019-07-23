/// This service gets one new row of data, sends it to PredictProcess and saves prediciton.
Class ml.engine.PredictService Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Property Adapter As Ens.InboundAdapter;

Property RS As %SQL.ISelectResult;

Property AtEnd As %Boolean [ InitialExpression = {$$$NO} ];

/// This user callback method is called via initConfig() from %OnNew() or in the case of SOAP Services from OnPreSOAP()
Method OnInit() As %Status
{
	#dim sc As %Status = $$$OK
	&sql(UPDATE ml_engine.Data SET prediction=NULL, diff=NULL)
	if ((SQLCODE'=0) && (SQLCODE'=100)) {
		set sc = $$$ERROR($$$SQLError, SQLCODE, $g(%msg))
		quit sc
	}
	
	&sql(DELETE FROM ml_engine.CheckData)
	if ((SQLCODE'=0) && (SQLCODE'=100)) {
		set sc = $$$ERROR($$$SQLError, SQLCODE, $g(%msg))
		quit sc
	}	
	set sc = ##class(%DeepSee.Utils).%BuildCube("CheckCube",,$$$NO)
	
	set ..RS = ##class(ml.engine.Data).ExtentFunc()

	quit sc
}

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	#dim sc As %Status = $$$OK
	quit:..AtEnd sc
	
	set count = 0
	while count<=10 {
		set count = count + 1
		set hasNext = ..RS.%Next(.sc)
		
		if hasNext=$$$NO {
			set ..AtEnd = $$$YES
			quit
			/*set sc = ..OnInit()
			quit:$$$ISERR(sc)
			do ..RS.%Next(.sc)
			quit:$$$ISERR(sc)*/
		}
		
		quit:$$$ISERR(sc)
		
		set id = ..RS.ID
		set predReq = ##class(Ens.StringRequest).%New(id)
		
		#dim predResp As Ens.StringResponse
		set sc = ..SendRequestSync(##class(ml.engine.PredictProcess).%ClassName(1), predReq, .predResp)
		quit:$$$ISERR(sc)
		
		&sql(UPDATE ml_engine.Data SET prediction=:predResp.StringValue, diff=(state-:predResp.StringValue) WHERE ID = :id)
		if (SQLCODE'=0) {
			set sc = $$$ERROR($$$SQLError, SQLCODE, $g(%msg))
			
		}
	}
	quit sc
}

}

