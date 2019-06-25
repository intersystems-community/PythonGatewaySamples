Class ml.match.Utils
{

/// Calculate default types: https://docs.dedupe.io/en/latest/Variable-definition.html
/// w ##class(ml.match.Utils).DedupeFields("ml.match.Restaurant")
ClassMethod DedupeFields(className As %Dictionary.CacheClassname) As %String
{
	set variable = []
	
	set exists = ##class(%Dictionary.CompiledClass).%ExistsId(className)
	throw:'exists ##class(%Exception.General).%New("<CLASS DOES NOT EXIST>", className)
	
	set propertyName=$$$comMemberNext(className, $$$cCLASSproperty, "")
	while propertyName'="" {
		set internal = $$$comMemberKeyGet(className, $$$cCLASSproperty, propertyName, $$$cPROPinternal)
		if ((internal '= $$$YES)) {
			do variable.%Push(..PropertyToField(className, propertyName))
		}
		set propertyName=$$$comMemberNext(className, $$$cCLASSproperty, propertyName)		
	}
	
	quit variable.%ToJSON()
}

ClassMethod PropertyToField(className As %Dictionary.CacheClassname, propertyName As %String) As %DynamicObject
{
	set field = {}
	
	set field.field = $$$comMemberKeyGet(className, $$$cCLASSproperty, propertyName, $$$cPROPsqlfieldname)
	set field.type = "String"
	set field."has missing" = ($$$comMemberKeyGet(className, $$$cCLASSproperty, propertyName, $$$cPROPrequired)="")

	quit field
}

}

