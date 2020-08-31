Class ml.cam.ens.bp.MatcherProcess Extends (Ens.BusinessProcessBPL, isc.py.ens.ProcessUtils) [ DependsOn = isc.py.ens.ProcessUtils ]
{

/// Python Operation we use to execute Python code
Property PythonOperation As %String(MAXLEN = 128) [ InitialExpression = "isc.py.ens.Operation" ];

/// Input image width. We convert image to this size before rescaling and passing it into nn.
Property Width As %Integer [ InitialExpression = 224 ];

/// Input image height. We convert image to this size before rescaling and passing it into nn.
Property Height As %Integer [ InitialExpression = 224 ];

/// How many matches to search for
Property Matches As %Integer [ InitialExpression = 5 ];

Parameter SETTINGS = "Height:ML,Width:ML,Matches:ML,PythonOperation:ML:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='ml.cam.ens.msg.MatchesRequest' response='ml.cam.ens.msg.MatchesResponse' >
<context>
<property name="cameraId" type="%Integer"/>
<property name="matches" type="%VarString"/>
</context>
<sequence >
<!--
<call name='' target='@..%Process.PythonOperation' async='1'>
<annotation><![CDATA[]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("")' action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for ' calls='' type='all' />-->

<call name='Load and Featurize image' target='@..%Process.PythonOperation' async='1'>
<annotation><![CDATA[
# Redirct stderr because of keras issues

mystderr = StringIO()
old_stderr = sys.stderr
sys.stderr = mystderr

# Convert pixel RGB values from int [0, 255] to float [0,1]
normalization_layer = tf.keras.layers.experimental.preprocessing.Rescaling(1./255)

f = r"#{process.%request.Target.Filename}"
data = tf.io.gfile.GFile(f, 'rb').read()
decoded = tf.image.decode_jpeg(data, channels=3)
resized = tf.image.resize(decoded, [#{process.Height}, #{process.Width}])
normalized = normalization_layer(resized)

targetVector = im([normalized])[0]
   
# Back with a regular stderr
sys.stdout = old_stderr

del data, decoded, resized, normalized, f, old_stderr, mystderr
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("Load and Featurize image")' action="set" />
<assign property="callrequest.SeparateLines" value="0" action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Load and Featurize image' calls='Load and Featurize image' type='all' />


<call name='Get matches' target='@..%Process.PythonOperation' async='1'>
<annotation><![CDATA[
# Find nearest matches to our target vector
n_nearest_neighbors = #{process.Matches}

nearest_neighbors, nearest_distances = t.get_nns_by_vector(targetVector, n_nearest_neighbors, include_distances=True)


leastDistances = {}
for index, j in enumerate(nearest_neighbors):
    leastDistances[str(nearest_distances[index])] = #{process.%request.IdVariable}[j]

]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("Get matches")' action="set" />
<assign property="callrequest.Variables" value='"nearest_neighbors,nearest_distances,leastDistances"' action="set" />
<assign property="callrequest.Serialization" value='"JSON"' action="set" />
<assign property="callrequest.SeparateLines" value="0" action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse'>
<assign property="context.matches" value='callresponse.Variables.GetAt("leastDistances")' action="set" />
</response>
</call>
<sync name='Wait for Get matches' calls='Get matches' type='all' />

<assign name="Fill Response" property="status" value="process.FillResponse()"/>


</sequence>
</process>
}

Method FillResponse() As %Status
{
	#dim sc As %Status = $$$OK
	
	set obj = {}.%FromJSON(..%Context.matches)
	
	set iterator = obj.%GetIterator()
	while iterator.%GetNext(.distance, .photoId) {
		do ..%response.Matches.SetAt(##class(ml.cam.data.Photo).%OpenId(+photoId), +distance)
	}
	
	quit sc
}

ClassMethod FilenameById(photoId) As %VarString [ CodeMode = expression ]
{
##class(ml.cam.data.Photo).DataGetStored(photoId)
}

Storage Default
{
<Data name="MatcherProcessDefaultData">
<Subscript>"MatcherProcess"</Subscript>
<Value name="1">
<Value>PythonOperation</Value>
</Value>
<Value name="2">
<Value>Width</Value>
</Value>
<Value name="3">
<Value>Height</Value>
</Value>
<Value name="4">
<Value>Matches</Value>
</Value>
</Data>
<DefaultData>MatcherProcessDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
}

}

