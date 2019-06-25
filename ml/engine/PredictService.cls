Class ml.engine.PredictService Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Property Adapter As Ens.InboundAdapter;

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	#dim sc As %Status = $$$OK
	&sql(UPDATE ml_engine.Data SET prediction=NULL, diff=NULL)
	if (SQLCODE'=0) {
		set sc = $$$ERROR($$$SQLError, SQLCODE, $g(%msg))
		quit sc
	}
	/// Really %sqlcq.<NAMESPACE>.cls<NUMBER>
	#dim rs As %SQL.ISelectResult
	set rs = ##class(ml.engine.Data).ExtentFunc()
	while rs.%Next() {
		set predReq = ##class(Ens.StringRequest).%New(rs.ID)
		
		#dim predResp As Ens.StringResponse
		set sc = ..SendRequestSync(##class(ml.engine.PredictProcess).%ClassName(1), predReq, .predResp)
		quit:$$$ISERR(sc)
		
		&sql(UPDATE ml_engine.Data SET prediction=:predResp.StringValue, diff=(state-:predResp.StringValue) WHERE ID = :rs.ID)
		if (SQLCODE'=0) {
			set sc = $$$ERROR($$$SQLError, SQLCODE, $g(%msg))
			quit
		}
	}
	

	quit sc
}

}

