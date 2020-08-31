Class ml.cam.ens.msg.LoaderRequest Extends %Persistent
{

/// Comma-separated Photo Ids
Property PhotoIds As %VarString [ Required ];

/// Python Variable holding the Photos
Property Variable As %String [ Required ];

/// Variable to hold corresponding images Ids on Python side
Property IdVariable As %String [ Required ];

Storage Default
{
<Data name="LoaderRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PhotoIds</Value>
</Value>
<Value name="3">
<Value>Variable</Value>
</Value>
<Value name="4">
<Value>IdVariable</Value>
</Value>
</Data>
<DataLocation>^ml.cam.ens.msg.LoaderRequestD</DataLocation>
<DefaultData>LoaderRequestDefaultData</DefaultData>
<IdLocation>^ml.cam.ens.msg.LoaderRequestD</IdLocation>
<IndexLocation>^ml.cam.ens.msg.LoaderRequestI</IndexLocation>
<StreamLocation>^ml.cam.ens.msg.LoaderRequestS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

