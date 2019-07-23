/// 
Class ml.engine.CheckCube Extends %DeepSee.CubeDefinition [ DependsOn = ml.engine.CheckData, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="CheckCube" displayName="CheckCube" disabled="false" abstract="false" sourceClass="ml.engine.CheckData" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false">
  <dimension name="CheckTime" disabled="false" hasAll="false" allCaption="All CheckTime" allDisplayName="CheckTime" sourceProperty="CheckTime" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Hour" disabled="false" timeFunction="HourNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="Minute" disabled="false" timeFunction="MinuteNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Retraining" disabled="false" hasAll="false" allCaption="All Retraining" allDisplayName="Retraining" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Retraining" disabled="false" sourceProperty="Retraining" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="Error" disabled="false" sourceProperty="Error" aggregate="AVG" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="Threshold" disabled="false" sourceProperty="Threshold" aggregate="AVG" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="MaxId" disabled="false" sourceProperty="MaxId" aggregate="AVG" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="MinId" disabled="false" sourceProperty="MinId" aggregate="AVG" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="Retraining" disabled="false" sourceProperty="Retraining" aggregate="AVG" type="integer" hidden="false" searchable="false">
  </measure>
</cube>
}

Parameter DOMAIN;

}

