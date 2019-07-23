/// Engine data
Class ml.engine.Data Extends %Persistent
{

/// Reading date
Property rDate As %Date;

/// Reading Time
Property rTime As %Time;

/// Sensor1 data
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

/// Our prediction (if any)
Property prediction As %Integer;

/// prediction == state
Property diff As %Integer;

/// True engine state
Property state As %Integer;

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

