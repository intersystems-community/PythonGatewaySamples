Class ml.titanic.Test Extends isc.py.util.BPEmulator
{

/// Init context and process variables
/// do ##class(ml.titanic.Test).Init()
ClassMethod Init() [ PublicList = (context, process) ]
{
	set context = {}
	set process = { "DropList": "['Name', 'Cabin', 'Ticket', 'Survived', 'Destination', 'Fare', 'Boat', 'Body']", 
					"PropertyY":"Survived",
					"%request": {}}
}

/// Execute sentiment process
/// do ##class(ml.titanic.Test).ExecuteTitanic()
ClassMethod ExecuteTitanic()
{
	set class = "ml.titanic.TrainProcess"
	set activities = $lb("Import", 
						 $lb("Load Data", "df"),
						 "Predict")
	do ..RunActivities(class, activities)
}

}

