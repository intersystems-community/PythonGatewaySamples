Class ml.cam.ens.msg.MatchesResponse Extends (%Persistent, Ens.Response)
{

/// distance1 - photo1
/// distance2 - photo2
Property Matches As array Of ml.cam.data.Photo;

Storage Default
{
<Data name="Matches">
<Attribute>Matches</Attribute>
<Structure>subnode</Structure>
<Subscript>"Matches"</Subscript>
</Data>
<Data name="MatchesResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^ml.cam.ensFD80.MatchesRespA00CD</DataLocation>
<DefaultData>MatchesResponseDefaultData</DefaultData>
<IdLocation>^ml.cam.ensFD80.MatchesRespA00CD</IdLocation>
<IndexLocation>^ml.cam.ensFD80.MatchesRespA00CI</IndexLocation>
<StreamLocation>^ml.cam.ensFD80.MatchesRespA00CS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

