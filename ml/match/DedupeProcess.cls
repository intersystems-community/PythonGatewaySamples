/// Using Dedupe library to deduplicate data 
Class ml.match.DedupeProcess Extends (Ens.BusinessProcessBPL, isc.py.ens.ProcessUtils) [ DependsOn = isc.py.ens.ProcessUtils ]
{

/// The rough limit of the number of training examples
Property TrainingSize As %Integer [ InitialExpression = 5000 ];

/// Save trained model in this file.
/// Set to empty to train new model every time
Property SettingsFile As %VarString [ InitialExpression = {##class(%File).NormalizeDirectory(##class(%SYS.System).TempDirectory()) _ "settings.pickle"} ];

/// Dedupe fields definition https://docs.dedupe.io/en/latest/Variable-definition.html
/// If it's a class, definitlion would be autocalculated from the class
Property Fields As %VarString [ InitialExpression = "ml.match.Restaurant" ];

/// Query to populate the dataset.
/// If not specified default query in BPL would be used
Property Query As %VarString;

Parameter SETTINGS = "TrainingSize:ML,SettingsFile:ML,Fields:ML,Query:ML";

Method GetFields()
{
	// Fields is not a class, but presumably a fields definition
	quit:'##class(%Dictionary.CompiledClass).%ExistsId(..Fields) ..Fields
	
	// Fields is a class, let's calculate the definition
	quit ##class(ml.match.Utils).DedupeFields(..Fields)
}

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
import dedupe
from itertools import combinations, groupby
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value="process.GetAnnotation(&quot;Import&quot;)" action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Import' calls='Import' type='all' />

<call name='Define' target='isc.py.ens.Operation' async='1' xpos='200' ypos='250' >
<annotation><![CDATA[
def todict(my_list):
    mydict = {}
    # 0th element in my_list is a header
    for row in my_list[1:]:
        mydict[row[0]] = dict(zip(my_list[0][1:], row[1:]))
    return mydict
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("Define")' action="set" />
<assign property="callrequest.SeparateLines" value="0" action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Define' calls='Define' type='all' />

<call name='Load Data' target='isc.py.ens.Operation' async='1' xpos='335' ypos='600' >
<annotation><![CDATA[SELECT Id, Name, Address, City, Cuisine, Cluster FROM ml_match.Restaurant]]></annotation>
<request type='isc.py.msg.QueryRequest' >
<assign property="callrequest.Query" value="$select(process.Query'=&quot;&quot;:process.Query, 1:process.GetAnnotation(&quot;Load Data&quot;))" action="set" />
<assign property="callrequest.Variable" value="&quot;data_l&quot;" action="set" />
<assign property="callrequest.Type" value="&quot;list&quot;" action="set" />
</request>
<response type='Ens.Response' />
</call>
<sync name='Wait for data' calls='Load Data' type='any' xpos='200' ypos='800' />

<call name='Transform' target='isc.py.ens.Operation' async='1' xpos='200' ypos='250' >
<annotation><![CDATA[
data_d = todict(data_l)
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("Transform")' action="set" />
<assign property="callrequest.Variables" value="&quot;data_d&quot;" action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Transform' calls='Transform' type='all' />

<call name='Transform pretrained data' target='isc.py.ens.Operation' async='1' xpos='200' ypos='250' >
<annotation><![CDATA[
# Construct training data for consumption by the ActiveLearning markPairs method from an already deduplicated dataset.
# Arguments:
#
# data - Dictionary of records, where the keys are record_ids and the values are dictionaries with the keys being field names
# common_key - The name of the record field that uniquely identifies a match
# training_size -- the rough limit of the number of training examples, defaults to 50000
# 
# Warning:
# 
# Every match must be identified by the sharing of a common key.
# This function assumes that if two records do not share a common key then they are distinct records.

training_pairs = dedupe.trainingDataDedupe(data_d, 'Cluster', #{process.TrainingSize})
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("Transform pretrained data")' action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Transform pretrained data' calls='Transform pretrained data' type='all' />

<if condition="##class(%File).Exists(process.SettingsFile)" name="Settings file exists?">
<true>
<call name='Load settings from file' target='isc.py.ens.Operation' async='1'>
<annotation><![CDATA[
with open(r'#{process.SettingsFile}', 'rb') as f:
    deduper = dedupe.StaticDedupe(f, 1)
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("Load settings from file")' action="set" />
<assign property="callrequest.SeparateLines" value="0" action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Load' calls='Load settings from file' type='all' />
</true>
<false>
<call name='Training' target='isc.py.ens.Operation' async='1'>
<annotation><![CDATA[
# fields = [{'field': 'Name', 'type': 'String'}, {'field': 'Name', 'type': 'Exact'}, {'field': 'Address', 'type': 'String'}, {'field': 'Cuisine', 'type': 'ShortString', 'has missing': True}, {'field': 'City', 'type': 'ShortString'} ]
fields = #{process.GetFields()}
deduper = dedupe.Dedupe(fields, num_cores=5)
deduper.sample(data_d, 10000)
deduper.markPairs(training_pairs)
deduper.train(index_predicates=False)
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("Training")' action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Training' calls='Training' type='all' />

<if condition="process.SettingsFile'=&quot;&quot;" name="SettingsFile is set?">
<true>
<call name='Write settings' target='isc.py.ens.Operation' async='1'>
<annotation><![CDATA[
with open(r'#{process.SettingsFile}', 'wb') as f:
    deduper.writeSettings(f)
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("Write settings")' action="set" />
<assign property="callrequest.SeparateLines" value="0" action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Write settings' calls='Write settings' type='all' />
</true>
</if>

</false>

</if>


<call name='Predict' target='isc.py.ens.Operation' async='1'>
<annotation><![CDATA[
alpha = deduper.threshold(data_d, 1)
clustered_dupes = deduper.match(data_d, threshold=alpha)
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("Predict")' action="set" />
<assign property="callrequest.Variables" value="&quot;clustered_dupes&quot;" action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Predict' calls='Predict' type='all' />

<call name='Validate' target='isc.py.ens.Operation' async='1'>
<annotation><![CDATA[
found_dupes = set([])
for dupes, score in clustered_dupes:
    for pair in combinations(dupes, 2):
        found_dupes.add(frozenset(pair))

true_dupes = set()
for _, pair in groupby(sorted(data_d.items(), key=lambda x: x[1]['Cluster']), key=lambda x: x[1]['Cluster']):
    pair = list(pair)
    if len(pair) == 2:
        a, b = pair
        true_dupes.add(frozenset((a[0], b[0])))

true_positives = found_dupes.intersection(true_dupes)
false_positives = found_dupes.difference(true_dupes)

true_positives_count = len(true_positives)
false_positives_count = len(false_positives)

found_count = len(found_dupes)
true_count = len(true_dupes)

precision = 1 - len(false_positives) / float(len(found_dupes))
recall = len(true_positives) / float(len(true_dupes))
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("Validate")' action="set" />
<assign property="callrequest.Variables" value='"found_dupes,true_dupes,true_positives_count,false_positives_count,found_count,true_count,precision,recall"' action="set" />
<assign property="callrequest.SeparateLines" value="0" action="set" />
<assign property="callrequest.Serialization" value="&quot;JSON&quot;" action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' >
<assign property="context.predictions" value="callresponse.Variables.GetAt(&quot;found_dupes&quot;)"/>
</response>
</call>
<sync name='Wait for Validate' calls='Validate' type='all' />

<assign name="Save predictions" property="status" value="##class(ml.match.Restaurant).UpdatePredictedCluster(context.predictions)" />

</sequence>
</process>
}

Storage Default
{
<Data name="DedupeProcessDefaultData">
<Subscript>"DedupeProcess"</Subscript>
<Value name="1">
<Value>SettingsFile</Value>
</Value>
<Value name="2">
<Value>TrainingSize</Value>
</Value>
<Value name="3">
<Value>Fields</Value>
</Value>
<Value name="4">
<Value>Query</Value>
</Value>
</Data>
<DefaultData>DedupeProcessDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
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

}

