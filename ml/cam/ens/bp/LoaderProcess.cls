Class ml.cam.ens.bp.LoaderProcess Extends (Ens.BusinessProcessBPL, isc.py.ens.ProcessUtils) [ DependsOn = isc.py.ens.ProcessUtils ]
{

/// Python Operation we use to execute Python code
Property PythonOperation As %String(MAXLEN = 128) [ InitialExpression = "isc.py.ens.Operation" ];

/// Which pretrained netwrk are we using
Property Network As %VarString [ InitialExpression = "https://tfhub.dev/google/imagenet/inception_v3/feature_vector/4" ];

/// Input image width. We convert image to this size before rescaling and passing it into nn.
Property Width As %Integer [ InitialExpression = 224 ];

/// Input image height. We convert image to this size before rescaling and passing it into nn.
Property Height As %Integer [ InitialExpression = 224 ];

/// How many images to process at once
Property Batch As %Integer [ InitialExpression = 127 ];

/// Where to save index 
/// Refer to this property from process proper with #{process.WorkDirectory}
Property WorkDirectory As %VarString [ InitialExpression = {##class(%File).NormalizeDirectory(##class(%SYS.System).TempDirectory())} ];

Parameter SETTINGS = "WorkDirectory:ML,Height:ML,Width:ML,Batch:ML,Network:ML,PythonOperation:ML:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='ml.cam.ens.msg.LoaderRequest' response='Ens.Response' >
<context>
<property name="pythonContext" type="%Integer"/>
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

<call name='Import modules' target='@..%Process.PythonOperation' async='1'>
<annotation><![CDATA[
import os
import tensorflow as tf
import tensorflow_hub as hub

from annoy import AnnoyIndex

from io import StringIO
import sys
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("Import modules")' action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Import modules' calls='Import modules' type='all' />

<call name='Init NN' target='@..%Process.PythonOperation' async='1'>
<annotation><![CDATA[
if 'im' not in globals():
    im = hub.KerasLayer('#{process.Network}')

#{process.%request.Variable} = []
images = []
n = 0
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("Init NN")' action="set" />
<assign property="callrequest.SeparateLines" value="0" action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for NN' calls='Init NN' type='all' />


<assign name="Find previous Python Context" property="context.pythonContext" value="process.GetContext()" />

<if condition="##class(isc.py.data.Context).%ExistsId(context.pythonContext)" name="Load from disk?">
<annotation>Load Data from Disk if available
</annotation>
<true>
<call name='Load context' target='@..%Process.PythonOperation' async='1'>
<annotation><![CDATA[Load Context (mainly Ids)
]]></annotation>
<request type='isc.py.msg.RestoreRequest' >
<assign property="callrequest.ContextId" value='context.pythonContext' action="set" />
</request>
<response type='Ens.Response' />
</call>
<sync name='Wait for Load context' calls='Load context' type='all' />

<call name='Load Index' target='@..%Process.PythonOperation' async='1'>
<annotation><![CDATA[
# Init (mmap) Annoy index from disk
t = AnnoyIndex(dims, metric='angular')

t.load(r'#{process.WorkDirectory}index.ann', prefault=True)
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("Load Index")' action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Load Index' calls='Load Index' type='all' />



</true>
<false>

<call name='Load and Featurize images' target='@..%Process.PythonOperation' async='1'>
<annotation><![CDATA[
# Redirct stderr because of keras issues

mystderr = StringIO()
old_stderr = sys.stderr
sys.stderr = mystderr

# Convert pixel RGB values from int [0, 255] to float [0,1]
normalization_layer = tf.keras.layers.experimental.preprocessing.Rescaling(1./255)

globals()['#{process.%request.IdVariable}'] = '#{process.%request.PhotoIds}'.split(',')

# batch load images into memory and calculate feature vectors
full_filenames = r"#{process.FilenamesByIds(process.%request.PhotoIds)}".split(',')
for (f) in full_filenames:
    data = tf.io.gfile.GFile(f, 'rb').read()
    decoded = tf.image.decode_jpeg(data, channels=3)
    resized = tf.image.resize(decoded, [#{process.Height}, #{process.Width}])
    normalized = normalization_layer(resized)
    images.append(normalized)

    if n == #{process.Batch}:
        #{process.%request.Variable}.extend(im(images))
        images.clear()
        n = 0
    else:
        n += 1

#{process.%request.Variable}.extend(im(images))
   
# Back with a regular stderr
sys.stdout = old_stderr

del images, n, data, decoded, resized, normalized, f, full_filenames, old_stderr, mystderr
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("Load and Featurize images")' action="set" />
<assign property="callrequest.SeparateLines" value="0" action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Load and Featurize images' calls='Load and Featurize images' type='all' />

<call name='Build Index' target='@..%Process.PythonOperation' async='1'>
<annotation><![CDATA[

dims = len(#{process.%request.Variable}[0])

# Init Annoy index and fill it with potential matches to our target
t = AnnoyIndex(dims, metric='angular')

for index, feature in enumerate(#{process.%request.Variable}):
    t.add_item(index, feature.numpy())


trees = 10000

# Build Annoy index
t.build(trees)
   
del index, feature, trees
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("Build Index")' action="set" />
<assign property="callrequest.SeparateLines" value="0" action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Build Index' calls='Build Index' type='all' />

<call name='Save context' target='@..%Process.PythonOperation' async='1'>
<annotation><![CDATA[Save imagesIds and dims for later reuse
]]></annotation>
<request type='isc.py.msg.SaveRequest' >
<assign property="callrequest.Mask" value='"imagesIds,dims"' action="set" />
<assign property="callrequest.Name" value='"ml.cam.ens.bp.LoaderProcess"' action="set" />
<assign property="callrequest.Description" value='process.WorkDirectory _ "index.ann"' action="set" />
</request>
<response type='Ens.StringResponse' />
</call>
<sync name='Wait for Save context' calls='Save context' type='all' />

<call name='Save index' target='@..%Process.PythonOperation' async='1'>
<annotation><![CDATA[
t.save(r'#{process.WorkDirectory}index.ann')
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value='process.GetAnnotation("Save index")' action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Save index' calls='Save index' type='all' />



</false>
</if>

</sequence>
</process>
}

/// set rs = ##class(ml.cam.ens.bp.LoaderProcess).ContextByDescriptionFunc(1243)
Query ContextByDescription(description As %VarString) As %SQLQuery
{
SELECT 
MAX(ID) Id
FROM isc_py_data.Context
WHERE Description = :description
}

Method GetContext() As %Integer
{
	set rs = ..ContextByDescriptionFunc(..WorkDirectory _ "index.ann")
	do rs.%Next()
	quit rs.Id
}

ClassMethod FilenamesByIds(photoIds) As %VarString
{
	set filenames = ""
	set length = $l(photoIds, ",")
	for i=1:1:length {
		set photoId = $p(photoIds, ",", i)
		set filename = ##class(ml.cam.data.Photo).DataGetStored(photoId)
		set filenames = filenames _ $lb(filename)
	}
	quit $lts(filenames)
}

/// Return an array of connections for drawing lines on the config diagram
ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	do ##class(isc.util.EnsUtils).getConnections("PythonOperation", pItem, .pArray)
}

Storage Default
{
<Data name="LoaderProcessDefaultData">
<Subscript>"LoaderProcess"</Subscript>
<Value name="1">
<Value>PythonOperation</Value>
</Value>
<Value name="2">
<Value>Network</Value>
</Value>
<Value name="3">
<Value>Width</Value>
</Value>
<Value name="4">
<Value>Height</Value>
</Value>
<Value name="5">
<Value>Batch</Value>
</Value>
<Value name="6">
<Value>WorkDirectory</Value>
</Value>
</Data>
<DefaultData>LoaderProcessDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
}

}

