/// History of model "validation"
Class ml.engine.CheckData Extends %Persistent
{

Property CheckTime As %TimeStamp [ InitialExpression = {$zdt($h, 3, 1)} ];

/// Error percentage
Property Error As %Integer;

/// Service threshold at the time
Property Threshold As %Integer;

/// First id used to determine error 
Property MinId As %Integer;

/// Last id used to determine error 
Property MaxId As %Integer;

/// Is retraining request sent
Property Retraining As %Boolean [ SqlComputeCode = {set {*} = ({Error} > {Threshold})}, SqlComputed, SqlComputeOnChange = %%INSERT ];

/// Add record
/// set sc = ##class(ml.engine.CheckData).Add()
ClassMethod Add(Error As %Integer, Threshold As %Integer, MinId As %Integer, MaxId As %Integer) As %Status
{
	set obj = ..%New()
	set obj.Error = Error
	set obj.Threshold = Threshold
	set obj.MinId = MinId
	set obj.MaxId = MaxId
	set sc = obj.%Save()
	quit:$$$ISERR(sc) sc
	
	set sc = ##class(%DeepSee.Utils).%ProcessFact("CheckCube", obj.%Id())
	quit sc
}

Storage Default
{
<Data name="CheckDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckTime</Value>
</Value>
<Value name="3">
<Value>Error</Value>
</Value>
<Value name="4">
<Value>Threshold</Value>
</Value>
<Value name="5">
<Value>MinId</Value>
</Value>
<Value name="6">
<Value>MaxId</Value>
</Value>
<Value name="7">
<Value>Retraining</Value>
</Value>
</Data>
<DataLocation>^ml.engine.CheckDataD</DataLocation>
<DefaultData>CheckDataDefaultData</DefaultData>
<IdLocation>^ml.engine.CheckDataD</IdLocation>
<IndexLocation>^ml.engine.CheckDataI</IndexLocation>
<StreamLocation>^ml.engine.CheckDataS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

