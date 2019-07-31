/// 
Class ml.titanic.TrainProcess Extends (Ens.BusinessProcessBPL, isc.py.ens.ProcessUtils) [ DependsOn = isc.py.ens.ProcessUtils ]
{

/// List of dataset columns to drop
/// Format: ['prop1', 'prop2', ..., 'propN']
Property DropList As %String(MAXLEN = 1000) [ InitialExpression = "['Name', 'Cabin', 'Ticket', 'Survived', 'Destination', 'Fare', 'Boat', 'Body']" ];

/// Target property of the dataset
Property PropertyY As %String(MAXLEN = 1000) [ InitialExpression = "Survived" ];

Parameter SETTINGS = "Table:ML,DropList:ML,PropertyY:ML";

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='2000' >
<context>
<property name="predictions" type="%VarString"/>
</context>
<sequence xend='200' yend='350' >
<call name='Import' target='isc.py.ens.Operation' async='1' xpos='200' ypos='250' >
<annotation><![CDATA[
from sklearn.tree import DecisionTreeClassifier
from sklearn.preprocessing import LabelEncoder
from sklearn.preprocessing import LabelBinarizer
from sklearn_pandas import DataFrameMapper
from sklearn.pipeline import Pipeline
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value="process.GetAnnotation(&quot;Import&quot;)" action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Import' calls='Import' type='all' />

<call name='Load Data' target='isc.py.ens.Operation' async='1' xpos='335' ypos='600' >
<annotation><![CDATA[SELECT * FROM ml_titanic.Passenger WHERE id>26]]></annotation>
<request type='isc.py.msg.QueryRequest' >
<assign property="callrequest.Query" value='process.GetAnnotation("Load Data")' action="set" />
<assign property="callrequest.Variable" value='"df"' action="set" />
<assign property="callrequest.Type" value='"dataframe"' action="set" />
</request>
<response type='Ens.Response' />
</call>
<sync name='Wait for data' calls='Load Data' type='any' xpos='200' ypos='800' />

<call name='Predict' target='isc.py.ens.Operation' async='1'>
<annotation><![CDATA[
# Extracting target variable Y
Y=df.#{process.PropertyY} 

# Dropping unneeded variables from trainig data
X=df.drop(columns=#{process.DropList})

pipeline = Pipeline([
    ('preprocessing', DataFrameMapper([
        ('Sex', LabelEncoder())])),
    ('tree', DecisionTreeClassifier())
])

pipeline.fit(X, Y)
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("Predict")' action="set" />
<assign property="callrequest.Variables" value="&quot;clustered_dupes&quot;" action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Predict' calls='Predict' type='all' />



</sequence>
</process>
}

XData EmptyCall
{
<xml>
<call name='' target='isc.py.ens.Operation' async='1'>
<annotation><![CDATA[
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("")' action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for ' calls='' type='all' />

<call name='' target='isc.py.ens.Operation' async='1'>
<annotation><![CDATA[]]></annotation>
<request type='isc.py.msg.QueryRequest' >
<assign property="callrequest.Query" value='process.GetAnnotation("")' action="set" />
<assign property="callrequest.Variable" value='""' action="set" />
<assign property="callrequest.Type" value='"list"' action="set" />
</request>
<response type='Ens.Response' />
</call>
<sync name='Wait for ' calls='' type='any'/>

</xml>
}

Storage Default
{
<Data name="TrainProcessDefaultData">
<Subscript>"TrainProcess"</Subscript>
<Value name="1">
<Value>DropList</Value>
</Value>
<Value name="2">
<Value>PropertyY</Value>
</Value>
</Data>
<DefaultData>TrainProcessDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
}

}

