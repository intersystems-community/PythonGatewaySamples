/// Using RLTK library to deduplicate data 
Class ml.match.RLTKProcess Extends (Ens.BusinessProcessBPL, isc.py.ens.ProcessUtils) [ DependsOn = isc.py.ens.ProcessUtils ]
{

/// Query to populate the dataset.
/// If not specified default query in BPL would be used
Property Query As %VarString;

/// Query to populate the true dataset.
/// If not specified default query in BPL would be used
Property TrueQuery As %VarString;

Parameter SETTINGS = "Query:Basic";

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
import recordlinkage
from recordlinkage.index import Full
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value="process.GetAnnotation(&quot;Import&quot;)" action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Import' calls='Import' type='all' />

<call name='Load Data' target='isc.py.ens.Operation' async='1' xpos='335' ypos='600' >
<annotation><![CDATA[SELECT Id, Name, Address, City, Cuisine FROM ml_match.Restaurant]]></annotation>
<request type='isc.py.msg.QueryRequest' >
<assign property="callrequest.Query" value="$select(process.Query'=&quot;&quot;:process.Query, 1:process.GetAnnotation(&quot;Load Data&quot;))" action="set" />
<assign property="callrequest.Variable" value='"dfA"' action="set" />
<assign property="callrequest.Type" value='"dataframe"' action="set" />
</request>
<response type='Ens.Response' />
</call>
<sync name='Wait for data' calls='Load Data' type='any' xpos='200' ypos='800' />

<call name='Predict' target='isc.py.ens.Operation' async='1'>
<annotation><![CDATA[
# Set row labels to ID
dfA.set_index('ID', inplace=True)

# Indexation step
indexer = recordlinkage.Index()
indexer.add(Full())
candidate_links = indexer.index(dfA)

# Comparison step
compare_cl = recordlinkage.Compare()

# compare_cl.string
# An approximate string comparison method. 
# Options are ['jaro', 'jarowinkler', 'levenshtein', 'damerau_levenshtein', 'qgram', 'cosine', 'smith_waterman', 'lcs'].
# Default: 'levenshtein'

compare_cl.string('Name', 'Name', method='jarowinkler', threshold=0.85, label='Name')
compare_cl.string('Address', 'Address', method='lcs', label='Address')
compare_cl.string('City', 'City', method='jarowinkler', threshold=0.85, label='City')
compare_cl.string('Cuisine', 'Cuisine', method='jarowinkler', threshold=0.85, label='Cuisine')

features = compare_cl.compute(candidate_links, dfA)

# Classification step
matches = features[features.sum(axis=1) > 3]
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("Predict")' action="set" />
<assign property="callrequest.Variables" value='"matches"' action="set" />
<assign property="callrequest.Serialization" value='"JSON"' action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' >
<assign property="context.predictions" value='callresponse.Variables.GetAt("matches")'/>
</response>
</call>
<sync name='Wait for Predict' calls='Predict' type='all' />

<assign disabled="true" name="Save predictions" property="status" value="##class(ml.match.Restaurant).UpdatePredictedClusterRLTK(context.predictions)" />


<call name='Load True Data' target='isc.py.ens.Operation' async='1' xpos='335' ypos='600' >
<annotation><![CDATA[
SELECT 
  max(ID) IdA, 
  min(ID) IdB
FROM ml_match.Restaurant
GROUP BY Cluster
 HAVING COUNT(1) = 2]]></annotation>
<request type='isc.py.msg.QueryRequest' >
<assign property="callrequest.Query" value="$select(process.Query'=&quot;&quot;:process.TrueQuery, 1:process.GetAnnotation(&quot;Load True Data&quot;))" action="set" />
<assign property="callrequest.Variable" value='"dfTrue"' action="set" />
<assign property="callrequest.Type" value='"dataframe"' action="set" />
</request>
<response type='Ens.Response' />
</call>
<sync name='Wait for True data' calls='Load True Data' type='any' xpos='200' ypos='800' />

<call name='Transform' target='isc.py.ens.Operation' async='1'>
<annotation><![CDATA[
true_matches = dfTrue.set_index(['IdA', 'IdB']).index
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("Transform")' action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Transform' calls='Transform' type='all' />

<call name='Validate' target='isc.py.ens.Operation' async='1'>
<annotation><![CDATA[
# Get the confusion matrix. This is just the table with the numbers of True/False Postives and True/False Negatives.
confusion_matrix = recordlinkage.confusion_matrix(true_matches, matches, len(features))

# Metrics
precision = recordlinkage.precision(confusion_matrix)
recall = recordlinkage.recall(confusion_matrix)
fmeasure = recordlinkage.fscore(confusion_matrix)
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("Validate")' action="set" />
<assign property="callrequest.Variables" value='"confusion_matrix,precision,recall,true_matches,fmeasure"' action="set" />
<assign property="callrequest.Serialization" value='"JSON"' action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Validate' calls='Validate' type='all' />

<call name='Logictic regression' target='isc.py.ens.Operation' async='1'>
<annotation><![CDATA[
from sklearn.model_selection import train_test_split

# Create a training and test set
train, test = train_test_split(features, test_size=0.25)

# Get the true pairs for each set
train_matches_index = train.index & true_matches
test_matches_index = test.index & true_matches

# Logistic Regression
# ***********************

# Initialize the classifier
classifier = recordlinkage.LogisticRegressionClassifier()

# Train the classifier
classifier.learn(train, train_matches_index)
# Make Predictions on a test set
predictions = classifier.predict(test)

# Get the confusion matrix. This is just the table with the numbers of True/False Postives and True/False Negatives.
confusion_matrix_log = recordlinkage.confusion_matrix(test_matches_index, predictions, len(test))

# Print Metrics
precision_log = recordlinkage.precision(confusion_matrix_log)
recall_log = recordlinkage.recall(confusion_matrix_log)
fmeasure_log = recordlinkage.fscore(confusion_matrix_log)
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("Logictic regression")' action="set" />
<assign property="callrequest.Variables" value='"predictions,predictions2,confusion_matrix_log,precision_log,recall_log,fmeasure_log"' action="set" />
<assign property="callrequest.Serialization" value='"JSON"' action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' >
<assign property="context.predictions" value='callresponse.Variables.GetAt("predictions")'/>
</response>
</call>
<sync name='Wait for Logictic regression' calls='Logictic regression' type='all' />


<assign name="Save predictions from LR" property="status" value="##class(ml.match.Restaurant).UpdatePredictedClusterRLTKLR(context.predictions)" />

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
<Data name="RLTKProcessDefaultData">
<Subscript>"RLTKProcess"</Subscript>
<Value name="1">
<Value>Query</Value>
</Value>
<Value name="2">
<Value>TrueQuery</Value>
</Value>
</Data>
<DefaultData>RLTKProcessDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
}

}

