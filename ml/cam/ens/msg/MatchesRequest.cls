Class ml.cam.ens.msg.MatchesRequest Extends (%Persistent, Ens.Request)
{

/// Target photo
Property Target As ml.cam.data.Photo [ Required ];

/// Variable holding corresponding PhotoIds on Python side
Property IdVariable As %String [ Required ];

Storage Default
{
<Data name="MatchesRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MatchesVariable</Value>
</Value>
<Value name="3">
<Value>TargetId</Value>
</Value>
<Value name="4">
<Value>IdVariable</Value>
</Value>
<Value name="5">
<Value>TargetPhoto</Value>
</Value>
<Value name="6">
<Value>Target</Value>
</Value>
</Data>
<DataLocation>^ml.cam.ens.msg.MatchesRequestD</DataLocation>
<DefaultData>MatchesRequestDefaultData</DefaultData>
<IdLocation>^ml.cam.ens.msg.MatchesRequestD</IdLocation>
<IndexLocation>^ml.cam.ens.msg.MatchesRequestI</IndexLocation>
<StreamLocation>^ml.cam.ens.msg.MatchesRequestS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

