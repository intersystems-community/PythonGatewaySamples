Class ml.cam.data.Photo Extends (%Persistent, %XML.Adaptor)
{

/// Link to file
Property Data As %Stream.FileBinary(XMLPROJECTION = "NONE");

/// Photo Filename
Property Filename As %VarString [ SqlComputeCode = {set {*} = ##class(ml.cam.data.Photo).DataGetStored({ID})}, SqlComputed, Transient ];

/// do ##class(ml.cam.data.Photo).LoadDir()
ClassMethod LoadDir(dir, recursive As %Boolean = {$$$YES})
{
	#dim sc As %Status = $$$OK
	 
	set rs = ##class(%File).FileSetFunc(dir, , , recursive)
	while rs.%Next() {
		if (rs.Type = "D") {
			set sc = ..LoadDir(rs.Name)
		} elseif (rs.Type = "F") {
			set sc = ..AddPhoto(rs.Name)
		}
		quit:$$$ISERR(sc)
	}
	
	quit sc
}

ClassMethod AddPhoto(file As %String) As %Status
{
	set photo = ..%New()
	do photo.Data.LinkToFile(file)
	quit photo.%Save()
}

Storage Default
{
<Data name="PhotoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Data</Value>
</Value>
</Data>
<DataLocation>^ml.cam.data.PhotoD</DataLocation>
<DefaultData>PhotoDefaultData</DefaultData>
<IdLocation>^ml.cam.data.PhotoD</IdLocation>
<IndexLocation>^ml.cam.data.PhotoI</IndexLocation>
<StreamLocation>^ml.cam.data.PhotoS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

