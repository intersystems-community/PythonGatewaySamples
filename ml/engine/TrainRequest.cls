Class ml.engine.TrainRequest Extends Ens.Request
{

Property StartId As %Integer [ InitialExpression = 1 ];

Property EndId As %Integer [ InitialExpression = 1000 ];

// {$g(^ml.engine.DataD,1)} ];

Storage Default
{
<Data name="TrainRequestDefaultData">
<Subscript>"TrainRequest"</Subscript>
<Value name="1">
<Value>StartId</Value>
</Value>
<Value name="2">
<Value>EndId</Value>
</Value>
</Data>
<DefaultData>TrainRequestDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
}

}

