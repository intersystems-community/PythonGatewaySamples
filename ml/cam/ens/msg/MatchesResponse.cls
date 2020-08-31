Class ml.cam.ens.msg.MatchesResponse Extends (Ens.Response, %Persistent)
{

/// distance1 - photo1
/// distance2 - photo2
Property Matches As array Of ml.cam.data.Photo;

Storage Default
{
<Data name="Matches">
<Attribute>Matches</Attribute>
<Structure>subnode</Structure>
<Subscript>"ml.cam.ens.msg.MatchesResponse.Matches"</Subscript>
</Data>
<Type>%Library.CacheStorage</Type>
}

}

