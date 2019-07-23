/// Process uses trained model to predict one engine state from sensors data
Class ml.engine.PredictProcess Extends (Ens.BusinessProcessBPL, isc.py.ens.ProcessUtils) [ DependsOn = isc.py.ens.ProcessUtils ]
{

/// Table to get data from
Property Table As %String(MAXLEN = 1000) [ InitialExpression = "ml_engine.Data" ];

Property DropList As %String(MAXLEN = 1000) [ InitialExpression = "['rDate', 'rTime', 'diff', 'prediction', 'state']" ];

Parameter SETTINGS = "WorkDirectory:Basic,Table:Basic,DropList:Basic";

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.StringRequest' response='Ens.StringResponse' >
<sequence >
<call name='Load Data' target='isc.py.ens.Operation' async='1'>
<annotation><![CDATA[SELECT * FROM #{process.Table} WHERE ID = #{process.%request.StringValue}]]></annotation>
<request type='isc.py.msg.QueryRequest' >
<assign property="callrequest.Query" value='process.GetAnnotation("Load Data")' action="set" />
<assign property="callrequest.Variable" value='"X1"' action="set" />
<assign property="callrequest.Type" value='"dataframe"' action="set" />
</request>
<response type='Ens.Response' />
</call>
<sync name='Wait for Load Data' calls='Load Data' type='any'/>

<call name='Clean input' target='isc.py.ens.Operation' async='1'>
<annotation><![CDATA[
# Dropping unneeded variables from our data row
X1=X1.drop(columns=#{process.DropList})
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("Clean input")' action="set" />
<assign property="callrequest.Variables" value='"X1"' action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Clean input' calls='Clean input' type='all' />

<call name='Predict' target='isc.py.ens.Operation' async='1'>
<annotation><![CDATA[
# Use the pipeline created in Training Process

prediction = pipe.predict(X1)
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("Predict")' action="set" />
<assign property="callrequest.Variables" value='"prediction"' action="set" />
<assign property="callrequest.Serialization" value='"JSON"' action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' >
<assign action="set" property="response.StringValue" value='[].%FromJSON(callresponse.Variables.GetAt("prediction")).%Get(0)' />
</response>
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

<assign property="callrequest.SeparateLines" value="0" action="set" />
<assign property="callrequest.Variables" value='""' action="set" />

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
<Data name="PredictProcessDefaultData">
<Subscript>"PredictProcess"</Subscript>
<Value name="1">
<Value>Table</Value>
</Value>
<Value name="2">
<Value>DropList</Value>
</Value>
</Data>
<DefaultData>PredictProcessDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
}

}

