Class ml.Production Extends Ens.Production
{

/// Register callout lib system-wide
ClassMethod OnStart(pTimeStarted As %String) As %Status
{
	set sc = ##class(isc.py.Callout).Setup()
	quit sc
}

XData ProductionDefinition
{
<Production Name="ml.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="ml.engine.InitService" Category="Engine" ClassName="ml.engine.InitService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="isc.py.ens.Operation" Category="Engine,Match,Cam" ClassName="isc.py.ens.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="PythonLib">libpython3.6m.so</Setting>
  </Item>
  <Item Name="ml.engine.CheckService" Category="Engine" ClassName="ml.engine.CheckService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">60</Setting>
  </Item>
  <Item Name="ml.engine.PredictService" Category="Engine" ClassName="ml.engine.PredictService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">.1</Setting>
  </Item>
  <Item Name="ml.engine.TrainProcess" Category="Engine" ClassName="ml.engine.TrainProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="ml.engine.PredictProcess" Category="Engine" ClassName="ml.engine.PredictProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="ml.match.DedupeProcess" Category="Match" ClassName="ml.match.DedupeProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="ml.match.RLTKProcess" Category="Match" ClassName="ml.match.RLTKProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="ml.cam.ens.bp.LoaderProcess" Category="Cam" ClassName="ml.cam.ens.bp.LoaderProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="Height">299</Setting>
    <Setting Target="Host" Name="Width">299</Setting>
  </Item>
  <Item Name="ml.cam.ens.bp.MatcherProcess" Category="Cam" ClassName="ml.cam.ens.bp.MatcherProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="Height">299</Setting>
    <Setting Target="Host" Name="Width">299</Setting>
    <Setting Target="Host" Name="Matches">9</Setting>
  </Item>
  <Item Name="ml.cam.ens.bs.InitService" Category="Cam" ClassName="ml.cam.ens.bs.InitService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
</Production>
}

}

