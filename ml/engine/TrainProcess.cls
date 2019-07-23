/// This is the core process. It trains predictive model from supplied data.
Class ml.engine.TrainProcess Extends (Ens.BusinessProcessBPL, isc.py.ens.ProcessUtils) [ DependsOn = isc.py.ens.ProcessUtils ]
{

/// Where to save images. 
/// Refer to this property from process proper with #{process.WorkDirectory}
Property WorkDirectory As %VarString [ InitialExpression = {##class(%File).NormalizeDirectory(##class(%SYS.System).TempDirectory())} ];

/// Table to get data from
Property Table As %String(MAXLEN = 1000) [ InitialExpression = "ml_engine.Data" ];

/// List of dataset columns to drop
Property DropList As %String(MAXLEN = 1000) [ InitialExpression = "['rDate', 'rTime', 'diff', 'prediction', 'state']" ];

/// Target property of the dataset
Property PropertyY As %String(MAXLEN = 1000) [ InitialExpression = "state" ];

Parameter SETTINGS = "WorkDirectory:Basic,Table:Basic,DropList:Basic,PropertyY:Basic";

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
<Data name="TrainProcessDefaultData">
<Subscript>"TrainProcess"</Subscript>
<Value name="1">
<Value>WorkDirectory</Value>
</Value>
<Value name="2">
<Value>Table</Value>
</Value>
<Value name="3">
<Value>DropList</Value>
</Value>
<Value name="4">
<Value>PropertyY</Value>
</Value>
</Data>
<DefaultData>TrainProcessDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='ml.engine.TrainRequest' response='Ens.StringResponse' height='2000' width='2000' >
<context>
<property name='StartId' type='%Integer' initialexpression='1' instantiate='0' />
<property name='EndId' type='%Integer' initialexpression='$g(^ml.engine.DataD,1)' instantiate='0' />
</context>
<sequence xend='200' yend='1650' >
<assign name="Check state values" property="status" value="process.HasDistinctStates(request.StartId, request.EndId, process.Table)"/>

<call name='Import' target='isc.py.ens.Operation' async='1' xpos='200' ypos='250' >
<annotation><![CDATA[
# Import required Python modules

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from sklearn.preprocessing import scale
from sklearn.decomposition import PCA
from sklearn.model_selection import KFold
from sklearn.model_selection import cross_validate
from sklearn.model_selection import cross_val_score
from sklearn.linear_model import LinearRegression
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import make_pipeline

import seaborn as sns
sns.set_style('darkgrid')
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value="process.GetAnnotation(&quot;Import&quot;)" action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Import' calls='Import' type='all' xpos='200' ypos='350' />
<call name='Load Data' target='isc.py.ens.Operation' async='1' xpos='200' ypos='450' >
<annotation><![CDATA[SELECT * FROM #{process.Table} WHERE ID BETWEEN #{process.%request.StartId} AND #{process.%request.EndId}]]></annotation>
<request type='isc.py.msg.QueryRequest' >
<assign property="callrequest.Query" value="process.GetAnnotation(&quot;Load Data&quot;)" action="set" />
<assign property="callrequest.Variable" value="&quot;df&quot;" action="set" />
<assign property="callrequest.Type" value="&quot;dataframe&quot;" action="set" />
</request>
<response type='Ens.Response' />
</call>
<sync name='Wait for Load Data' calls='Load Data' type='any' xpos='200' ypos='550' />
<call name='Extract Y' target='isc.py.ens.Operation' async='1' xpos='200' ypos='650' >
<annotation><![CDATA[
# df is set in 'Load Data' step

# Extracting target variable Y
Y=df.#{process.PropertyY} 

# Dropping unneeded variables from trainig data
X=df.drop(columns=#{process.DropList})
del df
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value="process.GetAnnotation(&quot;Extract Y&quot;)" action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Extract Y' calls='Extract Y' type='all' xpos='200' ypos='750' />
<call name='PCA' target='isc.py.ens.Operation' async='1' xpos='200' ypos='850' >
<annotation><![CDATA[
# Scikit-learn PCA
# Principal Component Analysis (PCA) is a dimension-reduction tool that can be used to reduce a large set of variables 
# to a small set that still contains most of the information in the large set.
# Principal component analysis (PCA) is a mathematical procedure that transforms a number of (possibly) correlated variables 
# into a (smaller) number of uncorrelated variables called principal components.
# The first principal component accounts for as much of the variability in the data as possible, and each succeeding component accounts for as much of the remaining variability as possible
pca = PCA()

# Scale and transform data to get Principal Components
X_reduced = pca.fit_transform(scale(X))

# Variance (% cumulative) explained by the principal components
variance = np.cumsum(np.round(pca.explained_variance_ratio_, decimals=4)*100)
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value="process.GetAnnotation(&quot;PCA&quot;)" action="set" />
<assign property="callrequest.Variables" value="&quot;variance&quot;" action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for PCA' calls='PCA' type='all' xpos='200' ypos='950' />
<call name='CV' target='isc.py.ens.Operation' async='1' xpos='200' ypos='1050' >
<annotation><![CDATA[
# Create mobject that randomly splits dataset into trainig and testing parts for validation
# 10-fold CV, with shuffle
kf_10 = KFold(n_splits=10, shuffle=True, random_state=2)

# Create empty Logistic Regression model
regr = LogisticRegression()

# List that would contain Mean Square Errors of different models
mse = []

# Do one CV to get MSE for just the intercept (no principal components in regression)

n = len(X_reduced)
score = -1*cross_val_score(regr, np.ones((n,1)), Y.ravel(), cv=kf_10, scoring='neg_mean_squared_error').mean()    
mse.append(score)

# Do CV for the 25 principle components, adding one component to the regression at the time
for i in np.arange(1,25):
    score = -1*cross_val_score(regr, X_reduced[:,:i], Y.ravel(), cv=kf_10, scoring='neg_mean_squared_error').mean()
    mse.append(score)
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value="process.GetAnnotation(&quot;CV&quot;)" action="set" />
<assign property="callrequest.SeparateLines" value="0" action="set" />
<assign property="callrequest.Variables" value="&quot;mse&quot;" action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for CV' calls='CV' type='all' xpos='200' ypos='1150' />
<call name='Fit' target='isc.py.ens.Operation' async='1' xpos='200' ypos='1250' >
<annotation><![CDATA[
# Create our pipeline, containig two steps: Principal Components Analysis transformation and Logistic Regression
pca = PCA()
regr = LogisticRegression()

pipe_temp = make_pipeline(pca, regr)

# Train the pipeline
pipe_temp.fit(X, Y)

# Switch the pipeline
pipe = pipe_temp
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value="process.GetAnnotation(&quot;Fit&quot;)" action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Fit' calls='Fit' type='all' xpos='200' ypos='1350' />
<call name='Plot' target='isc.py.ens.Operation' async='1' xpos='200' ypos='1450' >
<annotation><![CDATA[
# Graph MSE variable

fig, (ax1, ax2) = plt.subplots(1,2, figsize=(12,5))
ax1.plot(mse, '-v')
ax2.plot(list(range(1, 25)), mse[1:25], '-v')
ax2.set_title('Intercept excluded from plot')

for ax in fig.axes:
    ax.set_xlabel('Number of principal components in regression')
    ax.set_ylabel('MSE')
    ax.set_xlim((-0.2,25.2))
    
fig.savefig(r'#{process.WorkDirectory}MSE.png')
]]></annotation>
<request type='isc.py.msg.ExecutionRequest' >
<assign property="callrequest.Code" value="process.GetAnnotation(&quot;Plot&quot;)" action="set" />
<assign property="callrequest.SeparateLines" value="0" action="set" />
</request>
<response type='isc.py.msg.ExecutionResponse' />
</call>
<sync name='Wait for Plot' calls='Plot' type='all' xpos='200' ypos='1550' />
</sequence>
</process>
}

/// w ##class(ml.engine.TrainProcess).HasDistinctStates(1, 1000)
ClassMethod HasDistinctStates(StartId, EndId, Table = "ml_engine.Data") As %Status
{
	set count = 0
	set sql = "SELECT count(1) As ""Count"" " _ 
			  "FROM (SELECT 1 FROM " _ Table _ 
				   " WHERE ID BETWEEN ? AND ? " _ 
				   " GROUP BY state)"
	
	/// Really %sqlcq.<NAMESPACE>.cls<NUMBER>
	#dim rs As %SQL.ISelectResult
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql, StartId, EndId)

	do rs.%Next()
	set count = rs.Count
	
	quit:(count>1) $$$OK
	quit $$$ERROR($$$GeneralError, "Target variable has only one value")
}

}

