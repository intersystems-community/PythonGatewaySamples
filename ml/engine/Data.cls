Class ml.engine.Data Extends %Persistent
{

Property rDate As %Date;

Property rTime As %Time;

Property s1 As %Numeric(SCALE = 6);

Property s2 As %Numeric(SCALE = 6);

Property s3 As %Numeric(SCALE = 1);

Property s4 As %Numeric(SCALE = 6);

Property s5 As %Numeric(SCALE = 6);

Property s6 As %Numeric(SCALE = 6);

Property s7 As %Numeric(SCALE = 6);

Property s8 As %Numeric(SCALE = 1);

Property s9 As %Numeric(SCALE = 6);

Property s10 As %Numeric(SCALE = 6);

Property s11 As %Integer;

Property s12 As %Numeric(SCALE = 6);

Property s13 As %Integer;

Property s14 As %Numeric(SCALE = 6);

Property s15 As %Numeric(SCALE = 6);

Property s16 As %Numeric(SCALE = 6);

Property s17 As %Numeric(SCALE = 6);

Property s18 As %Numeric(SCALE = 6);

Property s19 As %Numeric(SCALE = 6);

Property s20 As %Numeric(SCALE = 6);

Property s21 As %Numeric(SCALE = 6);

Property s22 As %Numeric(SCALE = 6);

Property s23 As %Numeric(SCALE = 6);

Property s24 As %Numeric(SCALE = 6);

Property s25 As %Numeric(SCALE = 6);

Property s26 As %Numeric(SCALE = 6);

Property s27 As %Numeric(SCALE = 6);

Property s28 As %Numeric(SCALE = 6);

Property s29 As %Numeric(SCALE = 6);

Property s30 As %Numeric(SCALE = 6);

Property s31 As %Numeric(SCALE = 6);

Property s32 As %Numeric(SCALE = 6);

Property s33 As %Numeric(SCALE = 6);

Property s34 As %Numeric(SCALE = 6);

Property s35 As %Numeric(SCALE = 6);

Property s36 As %Numeric(SCALE = 6);

Property s37 As %Numeric(SCALE = 6);

Property s38 As %Numeric(SCALE = 6);

Property s39 As %Numeric(SCALE = 6);

Property s40 As %Numeric(SCALE = 6);

Property s41 As %Numeric(SCALE = 6);

Property s42 As %Numeric(SCALE = 6);

Property s43 As %Numeric(SCALE = 6);

Property s44 As %Numeric(SCALE = 6);

Property s45 As %Numeric(SCALE = 6);

/// %Numeric(SCALE = 6);
Property prediction As %Integer;

Property diff As %Integer;

Property state As %Integer;

/// d ##class(ml.engine.Data).Import("E:\PoC\Индекс_надежности\InterRAO\Test.csv")
/// d ##class(ml.engine.Data).Import("E:\PoC\Индекс_надежности\InterRAO\all_2016_edited.csv",,1000000)
ClassMethod Import(pFileName As %String(MAXLEN=""), pDelimiter As %String = ";", pMaxRows As %Integer = 0) As %Integer [ SqlProc ]
{
	set tQuote  = """"
	set tHeaders = 1
	set tStatementId = $SYSTEM.Util.CreateGUID(), tCounter = 0, pRecordCount = 0
	set tPreparedStatement = ##class(%SQL.DynamicStatement).Prepare(tStatementId,..#ROWTYPE,pDelimiter,tQuote,,,0,"CSV")
	if $Isobject(tPreparedStatement) {
		set tImporter = tPreparedStatement.%New(tPreparedStatement,,pFileName,pDelimiter,tQuote)
		#dim tImporter As %SQL.CSVResultSet
		if $Isobject(tImporter) {
			do ..%DeleteExtent(,.tDeleted,.tInstances,1)
				// burn the column headers
			for tPtr = 1:1:tHeaders { do tImporter.%Next() }
			
			set tLastDate = ""
			
			while tImporter.%Next() {
				set tMe = ..%New()
				
				CONTINUE:$e(tImporter.%GetData(2),1,2)=tLastDate
				set tLastDate = $e(tImporter.%GetData(2),1,2)
				
				try {
					set tMe.rDate = $zdh($tr(tImporter.%GetData(1),".","/"),4) // remove $tr on ILLEGAL VALUE error
				} catch ex {
					do ex.Log()
					zw tLastDate
					continue
				}
				//set tMe.rDate = $s('$system.CLS.IsMthd("rDateOdbcToLogical"):tImporter.%GetData(1),1:tMe.rDateOdbcToLogical(tImporter.%GetData(1)))
				set tMe.rTime = $zth($p(tImporter.%GetData(2),","),1)
				set tMe.s1 = $tr(tImporter.%GetData(3), ",", ".")
				set tMe.s2 = $tr(tImporter.%GetData(4), ",", ".")
				set tMe.s3 = $tr(tImporter.%GetData(5), ",", ".")
				set tMe.s4 = $tr(tImporter.%GetData(6), ",", ".")
				set tMe.s5 = $tr(tImporter.%GetData(7), ",", ".")
				set tMe.s6 = $tr(tImporter.%GetData(8), ",", ".")
				set tMe.s7 = $tr(tImporter.%GetData(9), ",", ".")
				set tMe.s8 = $tr(tImporter.%GetData(10), ",", ".")
				set tMe.s9 = $tr(tImporter.%GetData(11), ",", ".")
				set tMe.s10 = $tr(tImporter.%GetData(12), ",", ".")
				set tMe.s11 = $tr(tImporter.%GetData(13), ",", ".")
				set tMe.s12 = $tr(tImporter.%GetData(14), ",", ".")
				set tMe.s13 = $tr(tImporter.%GetData(15), ",", ".")
				set tMe.s14 = $tr(tImporter.%GetData(16), ",", ".")
				set tMe.s15 = $tr(tImporter.%GetData(17), ",", ".")
				set tMe.s16 = $tr(tImporter.%GetData(18), ",", ".")
				set tMe.s17 = $tr(tImporter.%GetData(19), ",", ".")
				set tMe.s18 = $tr(tImporter.%GetData(20), ",", ".")
				set tMe.s19 = $tr(tImporter.%GetData(21), ",", ".")
				set tMe.s20 = $tr(tImporter.%GetData(22), ",", ".")
				set tMe.s21 = $tr(tImporter.%GetData(23), ",", ".")
				set tMe.s22 = $tr(tImporter.%GetData(24), ",", ".")
				set tMe.s23 = $tr(tImporter.%GetData(25), ",", ".")
				set tMe.s24 = $tr(tImporter.%GetData(26), ",", ".")
				set tMe.s25 = $tr(tImporter.%GetData(27), ",", ".")
				set tMe.s26 = $tr(tImporter.%GetData(28), ",", ".")
				set tMe.s27 = $tr(tImporter.%GetData(29), ",", ".")
				set tMe.s28 = $tr(tImporter.%GetData(30), ",", ".")
				set tMe.s29 = $tr(tImporter.%GetData(31), ",", ".")
				set tMe.s30 = $tr(tImporter.%GetData(32), ",", ".")
				set tMe.s31 = $tr(tImporter.%GetData(33), ",", ".")
				set tMe.s32 = $tr(tImporter.%GetData(34), ",", ".")
				set tMe.s33 = $tr(tImporter.%GetData(35), ",", ".")
				set tMe.s34 = $tr(tImporter.%GetData(36), ",", ".")
				set tMe.s35 = $tr(tImporter.%GetData(37), ",", ".")
				set tMe.s36 = $tr(tImporter.%GetData(38), ",", ".")
				set tMe.s37 = $tr(tImporter.%GetData(39), ",", ".")
				set tMe.s38 = $tr(tImporter.%GetData(40), ",", ".")
				set tMe.s39 = $tr(tImporter.%GetData(41), ",", ".")
				set tMe.s40 = $tr(tImporter.%GetData(42), ",", ".")
				set tMe.s41 = $tr(tImporter.%GetData(43), ",", ".")
				set tMe.s42 = $tr(tImporter.%GetData(44), ",", ".")
				set tMe.s43 = $tr(tImporter.%GetData(45), ",", ".")
				set tMe.s44 = $tr(tImporter.%GetData(46), ",", ".")
				set tMe.s45 = $tr(tImporter.%GetData(47), ",", ".")

				set tStatus = tMe.%Save()
				if $$$ISOK(tStatus) { set tCounter = tCounter + 1 } else { w $System.Status.GetErrorText(tStatus) return}
				quit:((tCounter>=pMaxRows) && (pMaxRows>0))
			}
		}
	}
	set %sqlcontext.%SQLCODE = 0
	set %sqlcontext.%ROWCOUNT = tCounter
	quit tCounter
}

Parameter ROWTYPE = "DATE DATE, TIME TIME, 30XAA10CG801XQ01 NUMERIC(9,6), 30XAA12CS001XQ01 NUMERIC(9,6), 30XAV12CT001XQ01 NUMERIC(9,6), 30XAV12CP901XQ01 NUMERIC(9,6), 30XAA12CT051XQ01 NUMERIC(9,6), 30XAA12CT052XQ01 NUMERIC(9,6), 30XAA12CT053XQ01 NUMERIC(9,6), 30XAA12CT054XQ01 NUMERIC(9,6), 30XAA12CT055XQ01 NUMERIC(9,6), 30XAA12CT056XQ01 NUMERIC(9,6), 30LAC12CT051XQ01 NUMERIC(9,6), 30LAC12CT052XQ01 NUMERIC(9,6), 30LAC12CT053XQ01 NUMERIC(9,6), 30LAC12CT054XQ01 NUMERIC(9,6), 30LAC12CT055XQ01 NUMERIC(9,6), 30XAA12CY001XQ01 NUMERIC(9,6), 30XAA12CY002XQ01 NUMERIC(9,6), 30XAA12CY003XQ01 NUMERIC(9,6), 30XAA12CY004XQ01 NUMERIC(9,6), 30XAA12CY005XQ01 NUMERIC(9,6), 30XAA12CY006XQ01 NUMERIC(9,6), 30LAC12CY001XQ01 NUMERIC(9,6), 30LAC12CY002XQ01 NUMERIC(9,6), 30LAC12CY003XQ01 NUMERIC(9,6), 30LAC12CY004XQ01 NUMERIC(9,6), 30LAC12CY005XQ01 NUMERIC(9,6), 30LAC12CY006XQ01 NUMERIC(9,6), 30XAA12CY007XQ01 NUMERIC(9,6), 30LAC12CY007XQ01 NUMERIC(9,6), 30LAC12CY008XQ01 NUMERIC(9,6), 30LAC12CY009XQ01 NUMERIC(9,6), 30LBG40CT001XQ01 NUMERIC(9,6), 30LBG40CP001XQ01 NUMERIC(9,6), 30LBG50CT001XQ01 NUMERIC(9,6), 30LBG50CP901XQ01 NUMERIC(9,6), 30LAB12CP901XQ01 NUMERIC(9,6), 30LAB12CT001XQ01 NUMERIC(9,6), 30LAC12CT001XQ01 NUMERIC(9,6), 30LAB12CP902XQ01 NUMERIC(9,6), 30LAB12CT002XQ01 NUMERIC(9,6), 30LAB12CF901XQ01 NUMERIC(9,6), 30LAF10CT001XQ01 NUMERIC(9,6), 30LAF10CP001XQ01 NUMERIC(9,6), 30LAW20CP001XQ01 NUMERIC(9,6), 30LAW21CP001XQ01 NUMERIC(9,6)";

Storage Default
{
<Data name="DataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>rDate</Value>
</Value>
<Value name="3">
<Value>rTime</Value>
</Value>
<Value name="4">
<Value>s1</Value>
</Value>
<Value name="5">
<Value>s2</Value>
</Value>
<Value name="6">
<Value>s3</Value>
</Value>
<Value name="7">
<Value>s4</Value>
</Value>
<Value name="8">
<Value>s5</Value>
</Value>
<Value name="9">
<Value>s6</Value>
</Value>
<Value name="10">
<Value>s7</Value>
</Value>
<Value name="11">
<Value>s8</Value>
</Value>
<Value name="12">
<Value>s9</Value>
</Value>
<Value name="13">
<Value>s10</Value>
</Value>
<Value name="14">
<Value>s11</Value>
</Value>
<Value name="15">
<Value>s12</Value>
</Value>
<Value name="16">
<Value>s13</Value>
</Value>
<Value name="17">
<Value>s14</Value>
</Value>
<Value name="18">
<Value>s15</Value>
</Value>
<Value name="19">
<Value>s16</Value>
</Value>
<Value name="20">
<Value>s17</Value>
</Value>
<Value name="21">
<Value>s18</Value>
</Value>
<Value name="22">
<Value>s19</Value>
</Value>
<Value name="23">
<Value>s20</Value>
</Value>
<Value name="24">
<Value>s21</Value>
</Value>
<Value name="25">
<Value>s22</Value>
</Value>
<Value name="26">
<Value>s23</Value>
</Value>
<Value name="27">
<Value>s24</Value>
</Value>
<Value name="28">
<Value>s25</Value>
</Value>
<Value name="29">
<Value>s26</Value>
</Value>
<Value name="30">
<Value>s27</Value>
</Value>
<Value name="31">
<Value>s28</Value>
</Value>
<Value name="32">
<Value>s29</Value>
</Value>
<Value name="33">
<Value>s30</Value>
</Value>
<Value name="34">
<Value>s31</Value>
</Value>
<Value name="35">
<Value>s32</Value>
</Value>
<Value name="36">
<Value>s33</Value>
</Value>
<Value name="37">
<Value>s34</Value>
</Value>
<Value name="38">
<Value>s35</Value>
</Value>
<Value name="39">
<Value>s36</Value>
</Value>
<Value name="40">
<Value>s37</Value>
</Value>
<Value name="41">
<Value>s38</Value>
</Value>
<Value name="42">
<Value>s39</Value>
</Value>
<Value name="43">
<Value>s40</Value>
</Value>
<Value name="44">
<Value>s41</Value>
</Value>
<Value name="45">
<Value>s42</Value>
</Value>
<Value name="46">
<Value>s43</Value>
</Value>
<Value name="47">
<Value>s44</Value>
</Value>
<Value name="48">
<Value>s45</Value>
</Value>
<Value name="49">
<Value>prediction</Value>
</Value>
<Value name="50">
<Value>diff</Value>
</Value>
<Value name="51">
<Value>state</Value>
</Value>
</Data>
<DataLocation>^ml.engine.DataD</DataLocation>
<DefaultData>DataDefaultData</DefaultData>
<IdLocation>^ml.engine.DataD</IdLocation>
<IndexLocation>^ml.engine.DataI</IndexLocation>
<StreamLocation>^ml.engine.DataS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

