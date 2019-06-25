/// Restraunt addresses. Call Import to populate the table.
/// do ##class(ml.match.Restaurant).Import()
/// zw ##class(ml.match.Restaurant).Export()
Class ml.match.Restaurant Extends (%Persistent, isc.py.util.Storage)
{

/// Name of XData block that stores our data for population 
Parameter XDATA = "Data";

Property Name As %String [ Required ];

Property Address As %String;

Property City As %String;

Property Cuisine As %String;

/// If two records have the same cluster, they refer to the same entity
Property Cluster As %Integer [ Internal ];

/// Predicted value of cluster
Property PredictedCluster As %String [ Internal ];

/// set sc = ##class(ml.match.Restaurant).UpdatePredictedCluster()
ClassMethod UpdatePredictedCluster(json As %String) As %Status
{
	#dim sc As %Status = $$$OK
	&sql(UPDATE ml_match.Restaurant SET PredictedCluster = NULL)
	
	set obj = {}.%FromJSON(json)
	set iterator = obj.%GetIterator()

	set cluster = 0
	while iterator.%GetNext(.key, .value) {
		#dim value As %DynamicArray
		set aid = value.%Get(0)
		set bid = value.%Get(1)
		
		set cluster = cluster + 1
		
		set $list(^ml.match.RestaurantD(aid), 7) = cluster
		set $list(^ml.match.RestaurantD(bid), 7) = cluster
	}
	
	quit sc
}

/// set sc = ##class(ml.match.Restaurant).UpdatePredictedClusterRLTK()
ClassMethod UpdatePredictedClusterRLTK(json As %String) As %Status
{
	#dim sc As %Status = $$$OK
	&sql(UPDATE ml_match.Restaurant SET PredictedCluster = NULL)
	
	set obj = {}.%FromJSON(json)
	set iterator = obj.Name.%GetIterator()

	set cluster = 0
	while iterator.%GetNext(.key, .value) {
		set keyObj = [].%FromJSON(key)
		#dim value As %DynamicArray
		set aid = keyObj.%Get(0)
		set bid = keyObj.%Get(1)
		
		set cluster = cluster + 1
		
		set $list(^ml.match.RestaurantD(aid), 7) = cluster
		set $list(^ml.match.RestaurantD(bid), 7) = cluster
	}
	
	quit sc
}

/// set sc = ##class(ml.match.Restaurant).UpdatePredictedClusterRLTKLR()
ClassMethod UpdatePredictedClusterRLTKLR(json As %String) As %Status
{
	#dim sc As %Status = $$$OK
	&sql(UPDATE ml_match.Restaurant SET PredictedCluster = NULL)
	
	set obj = {}.%FromJSON(json)
	set iterator = obj."_tuples".%GetIterator()

	set cluster = 0
	while iterator.%GetNext(.key, .value) {
		set aid = value.%Get(0)
		set bid = value.%Get(1)
		
		set cluster = cluster + 1
		
		set $list(^ml.match.RestaurantD(aid), 7) = cluster
		set $list(^ml.match.RestaurantD(bid), 7) = cluster
	}
	
	quit sc
}

XData Data
{
<xml>
<Restaurant><Name>arnie morton's of chicago</Name><Address>435 s. la cienega blv.</Address><City>los angeles</City><Cuisine>american</Cuisine><Cluster>0</Cluster></Restaurant>
<Restaurant><Name>arnie morton's of chicago</Name><Address>435 s. la cienega blvd.</Address><City>los angeles</City><Cuisine>steakhouses</Cuisine><Cluster>0</Cluster></Restaurant>
<Restaurant><Name>art's delicatessen</Name><Address>12224 ventura blvd.</Address><City>studio city</City><Cuisine>american</Cuisine><Cluster>1</Cluster></Restaurant>
<Restaurant><Name>art's deli</Name><Address>12224 ventura blvd.</Address><City>studio city</City><Cuisine>delis</Cuisine><Cluster>1</Cluster></Restaurant>
<Restaurant><Name>hotel bel-air</Name><Address>701 stone canyon rd.</Address><City>bel air</City><Cuisine>californian</Cuisine><Cluster>2</Cluster></Restaurant>
<Restaurant><Name>bel-air hotel</Name><Address>701 stone canyon rd.</Address><City>bel air</City><Cuisine>californian</Cuisine><Cluster>2</Cluster></Restaurant>
<Restaurant><Name>cafe bizou</Name><Address>14016 ventura blvd.</Address><City>sherman oaks</City><Cuisine>french</Cuisine><Cluster>3</Cluster></Restaurant>
<Restaurant><Name>cafe bizou</Name><Address>14016 ventura blvd.</Address><City>sherman oaks</City><Cuisine>french bistro</Cuisine><Cluster>3</Cluster></Restaurant>
<Restaurant><Name>campanile</Name><Address>624 s. la brea ave.</Address><City>los angeles</City><Cuisine>american</Cuisine><Cluster>4</Cluster></Restaurant>
<Restaurant><Name>campanile</Name><Address>624 s. la brea ave.</Address><City>los angeles</City><Cuisine>californian</Cuisine><Cluster>4</Cluster></Restaurant>
<Restaurant><Name>chinois on main</Name><Address>2709 main st.</Address><City>santa monica</City><Cuisine>french</Cuisine><Cluster>5</Cluster></Restaurant>
<Restaurant><Name>chinois on main</Name><Address>2709 main st.</Address><City>santa monica</City><Cuisine>pacific new wave</Cuisine><Cluster>5</Cluster></Restaurant>
<Restaurant><Name>citrus</Name><Address>6703 melrose ave.</Address><City>los angeles</City><Cuisine>californian</Cuisine><Cluster>6</Cluster></Restaurant>
<Restaurant><Name>citrus</Name><Address>6703 melrose ave.</Address><City>los angeles</City><Cuisine>californian</Cuisine><Cluster>6</Cluster></Restaurant>
<Restaurant><Name>fenix</Name><Address>8358 sunset blvd. west</Address><City>hollywood</City><Cuisine>american</Cuisine><Cluster>7</Cluster></Restaurant>
<Restaurant><Name>fenix at the argyle</Name><Address>8358 sunset blvd.</Address><City>w. hollywood</City><Cuisine>french (new)</Cuisine><Cluster>7</Cluster></Restaurant>
<Restaurant><Name>granita</Name><Address>23725 w. malibu rd.</Address><City>malibu</City><Cuisine>californian</Cuisine><Cluster>8</Cluster></Restaurant>
<Restaurant><Name>granita</Name><Address>23725 w. malibu rd.</Address><City>malibu</City><Cuisine>californian</Cuisine><Cluster>8</Cluster></Restaurant>
<Restaurant><Name>grill on the alley</Name><Address>9560 dayton way</Address><City>los angeles</City><Cuisine>american</Cuisine><Cluster>9</Cluster></Restaurant>
<Restaurant><Name>grill  the</Name><Address>9560 dayton way</Address><City>beverly hills</City><Cuisine>american (traditional)</Cuisine><Cluster>9</Cluster></Restaurant>
<Restaurant><Name>restaurant katsu</Name><Address>1972 n. hillhurst ave.</Address><City>los angeles</City><Cuisine>asian</Cuisine><Cluster>10</Cluster></Restaurant>
<Restaurant><Name>katsu</Name><Address>1972 hillhurst ave.</Address><City>los feliz</City><Cuisine>japanese</Cuisine><Cluster>10</Cluster></Restaurant>
<Restaurant><Name>l'orangerie</Name><Address>903 n. la cienega blvd.</Address><City>los angeles</City><Cuisine>french</Cuisine><Cluster>11</Cluster></Restaurant>
<Restaurant><Name>l'orangerie</Name><Address>903 n. la cienega blvd.</Address><City>w. hollywood</City><Cuisine>french (classic)</Cuisine><Cluster>11</Cluster></Restaurant>
<Restaurant><Name>le chardonnay</Name><Address>8284 melrose ave.</Address><City>los angeles</City><Cuisine>french</Cuisine><Cluster>12</Cluster></Restaurant>
<Restaurant><Name>le chardonnay (los angeles)</Name><Address>8284 melrose ave.</Address><City>los angeles</City><Cuisine>french bistro</Cuisine><Cluster>12</Cluster></Restaurant>
<Restaurant><Name>locanda veneta</Name><Address>3rd st.</Address><City>los angeles</City><Cuisine>italian</Cuisine><Cluster>13</Cluster></Restaurant>
<Restaurant><Name>locanda veneta</Name><Address>8638 w. third st.</Address><City>los angeles</City><Cuisine>italian</Cuisine><Cluster>13</Cluster></Restaurant>
<Restaurant><Name>matsuhisa</Name><Address>129 n. la cienega blvd.</Address><City>beverly hills</City><Cuisine>asian</Cuisine><Cluster>14</Cluster></Restaurant>
<Restaurant><Name>matsuhisa</Name><Address>129 n. la cienega blvd.</Address><City>beverly hills</City><Cuisine>seafood</Cuisine><Cluster>14</Cluster></Restaurant>
<Restaurant><Name>the palm</Name><Address>9001 santa monica blvd.</Address><City>los angeles</City><Cuisine>american</Cuisine><Cluster>15</Cluster></Restaurant>
<Restaurant><Name>palm  the (los angeles)</Name><Address>9001 santa monica blvd.</Address><City>w. hollywood</City><Cuisine>steakhouses</Cuisine><Cluster>15</Cluster></Restaurant>
<Restaurant><Name>patina</Name><Address>5955 melrose ave.</Address><City>los angeles</City><Cuisine>californian</Cuisine><Cluster>16</Cluster></Restaurant>
<Restaurant><Name>patina</Name><Address>5955 melrose ave.</Address><City>los angeles</City><Cuisine>californian</Cuisine><Cluster>16</Cluster></Restaurant>
<Restaurant><Name>philippe's the original</Name><Address>1001 n. alameda st.</Address><City>los angeles</City><Cuisine>american</Cuisine><Cluster>17</Cluster></Restaurant>
<Restaurant><Name>philippe the original</Name><Address>1001 n. alameda st.</Address><City>chinatown</City><Cuisine>cafeterias</Cuisine><Cluster>17</Cluster></Restaurant>
<Restaurant><Name>pinot bistro</Name><Address>12969 ventura blvd.</Address><City>los angeles</City><Cuisine>french</Cuisine><Cluster>18</Cluster></Restaurant>
<Restaurant><Name>pinot bistro</Name><Address>12969 ventura blvd.</Address><City>studio city</City><Cuisine>french bistro</Cuisine><Cluster>18</Cluster></Restaurant>
<Restaurant><Name>rex il ristorante</Name><Address>617 s. olive st.</Address><City>los angeles</City><Cuisine>italian</Cuisine><Cluster>19</Cluster></Restaurant>
<Restaurant><Name>rex il ristorante</Name><Address>617 s. olive st.</Address><City>los angeles</City><Cuisine>nuova cucina italian</Cuisine><Cluster>19</Cluster></Restaurant>
<Restaurant><Name>spago</Name><Address>1114 horn ave.</Address><City>los angeles</City><Cuisine>californian</Cuisine><Cluster>20</Cluster></Restaurant>
<Restaurant><Name>spago (los angeles)</Name><Address>8795 sunset blvd.</Address><City>w. hollywood</City><Cuisine>californian</Cuisine><Cluster>20</Cluster></Restaurant>
<Restaurant><Name>valentino</Name><Address>3115 pico blvd.</Address><City>santa monica</City><Cuisine>italian</Cuisine><Cluster>21</Cluster></Restaurant>
<Restaurant><Name>valentino</Name><Address>3115 pico blvd.</Address><City>santa monica</City><Cuisine>italian</Cuisine><Cluster>21</Cluster></Restaurant>
<Restaurant><Name>yujean kang's gourmet chinese cuisine</Name><Address>67 n. raymond ave.</Address><City>los angeles</City><Cuisine>asian</Cuisine><Cluster>22</Cluster></Restaurant>
<Restaurant><Name>yujean kang's</Name><Address>67 n. raymond ave.</Address><City>pasadena</City><Cuisine>chinese</Cuisine><Cluster>22</Cluster></Restaurant>
<Restaurant><Name>21 club</Name><Address>21 w. 52nd st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>23</Cluster></Restaurant>
<Restaurant><Name>21 club</Name><Address>21 w. 52nd st.</Address><City>new york city</City><Cuisine>american (new)</Cuisine><Cluster>23</Cluster></Restaurant>
<Restaurant><Name>aquavit</Name><Address>13 w. 54th st.</Address><City>new york</City><Cuisine>continental</Cuisine><Cluster>24</Cluster></Restaurant>
<Restaurant><Name>aquavit</Name><Address>13 w. 54th st.</Address><City>new york city</City><Cuisine>scandinavian</Cuisine><Cluster>24</Cluster></Restaurant>
<Restaurant><Name>aureole</Name><Address>34 e. 61st st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>25</Cluster></Restaurant>
<Restaurant><Name>aureole</Name><Address>34 e. 61st st.</Address><City>new york city</City><Cuisine>american (new)</Cuisine><Cluster>25</Cluster></Restaurant>
<Restaurant><Name>cafe lalo</Name><Address>201 w. 83rd st.</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>26</Cluster></Restaurant>
<Restaurant><Name>cafe lalo</Name><Address>201 w. 83rd st.</Address><City>new york city</City><Cuisine>coffeehouses</Cuisine><Cluster>26</Cluster></Restaurant>
<Restaurant><Name>cafe des artistes</Name><Address>1 w. 67th st.</Address><City>new york</City><Cuisine>continental</Cuisine><Cluster>27</Cluster></Restaurant>
<Restaurant><Name>cafe des artistes</Name><Address>1 w. 67th st.</Address><City>new york city</City><Cuisine>french (classic)</Cuisine><Cluster>27</Cluster></Restaurant>
<Restaurant><Name>carmine's</Name><Address>2450 broadway  between 90th and 91st sts.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>28</Cluster></Restaurant>
<Restaurant><Name>carmine's</Name><Address>2450 broadway</Address><City>new york city</City><Cuisine>italian</Cuisine><Cluster>28</Cluster></Restaurant>
<Restaurant><Name>carnegie deli</Name><Address>854 7th ave.  between 54th and 55th sts.</Address><City>new york</City><Cuisine>delicatessen</Cuisine><Cluster>29</Cluster></Restaurant>
<Restaurant><Name>carnegie deli</Name><Address>854 seventh ave.</Address><City>new york city</City><Cuisine>delis</Cuisine><Cluster>29</Cluster></Restaurant>
<Restaurant><Name>chanterelle</Name><Address>2 harrison st.  near hudson st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>30</Cluster></Restaurant>
<Restaurant><Name>chanterelle</Name><Address>2 harrison st.</Address><City>new york city</City><Cuisine>french (new)</Cuisine><Cluster>30</Cluster></Restaurant>
<Restaurant><Name>daniel</Name><Address>20 e. 76th st.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>31</Cluster></Restaurant>
<Restaurant><Name>daniel</Name><Address>20 e. 76th st.</Address><City>new york city</City><Cuisine>french (new)</Cuisine><Cluster>31</Cluster></Restaurant>
<Restaurant><Name>dawat</Name><Address>210 e. 58th st.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>32</Cluster></Restaurant>
<Restaurant><Name>dawat</Name><Address>210 e. 58th st.</Address><City>new york city</City><Cuisine>indian</Cuisine><Cluster>32</Cluster></Restaurant>
<Restaurant><Name>felidia</Name><Address>243 e. 58th st.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>33</Cluster></Restaurant>
<Restaurant><Name>felidia</Name><Address>243 e. 58th st.</Address><City>new york city</City><Cuisine>italian</Cuisine><Cluster>33</Cluster></Restaurant>
<Restaurant><Name>four seasons grill room</Name><Address>99 e. 52nd st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>34</Cluster></Restaurant>
<Restaurant><Name>four seasons</Name><Address>99 e. 52nd st.</Address><City>new york city</City><Cuisine>american (new)</Cuisine><Cluster>34</Cluster></Restaurant>
<Restaurant><Name><![CDATA[gotham bar & grill]]></Name><Address>12 e. 12th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>35</Cluster></Restaurant>
<Restaurant><Name><![CDATA[gotham bar & grill]]></Name><Address>12 e. 12th st.</Address><City>new york city</City><Cuisine>american (new)</Cuisine><Cluster>35</Cluster></Restaurant>
<Restaurant><Name>gramercy tavern</Name><Address>42 e. 20th st.  between park ave. s and broadway</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>36</Cluster></Restaurant>
<Restaurant><Name>gramercy tavern</Name><Address>42 e. 20th st.</Address><City>new york city</City><Cuisine>american (new)</Cuisine><Cluster>36</Cluster></Restaurant>
<Restaurant><Name>island spice</Name><Address>402 w. 44th st.</Address><City>new york</City><Cuisine>tel caribbean</Cuisine><Cluster>37</Cluster></Restaurant>
<Restaurant><Name>island spice</Name><Address>402 w. 44th st.</Address><City>new york city</City><Cuisine>caribbean</Cuisine><Cluster>37</Cluster></Restaurant>
<Restaurant><Name>jo jo</Name><Address>160 e. 64th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>38</Cluster></Restaurant>
<Restaurant><Name>jo jo</Name><Address>160 e. 64th st.</Address><City>new york city</City><Cuisine>french bistro</Cuisine><Cluster>38</Cluster></Restaurant>
<Restaurant><Name>la caravelle</Name><Address>33 w. 55th st.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>39</Cluster></Restaurant>
<Restaurant><Name>la caravelle</Name><Address>33 w. 55th st.</Address><City>new york city</City><Cuisine>french (classic)</Cuisine><Cluster>39</Cluster></Restaurant>
<Restaurant><Name>la cote basque</Name><Address>60 w. 55th st.  between 5th and 6th ave.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>40</Cluster></Restaurant>
<Restaurant><Name>la cote basque</Name><Address>60 w. 55th st.</Address><City>new york city</City><Cuisine>french (classic)</Cuisine><Cluster>40</Cluster></Restaurant>
<Restaurant><Name>le bernardin</Name><Address>155 w. 51st st.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>41</Cluster></Restaurant>
<Restaurant><Name>le bernardin</Name><Address>155 w. 51st st.</Address><City>new york city</City><Cuisine>seafood</Cuisine><Cluster>41</Cluster></Restaurant>
<Restaurant><Name>les celebrites</Name><Address>160 central park s</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>42</Cluster></Restaurant>
<Restaurant><Name>les celebrites</Name><Address>155 w. 58th st.</Address><City>new york city</City><Cuisine>french (classic)</Cuisine><Cluster>42</Cluster></Restaurant>
<Restaurant><Name>lespinasse</Name><Address>2 e. 55th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>43</Cluster></Restaurant>
<Restaurant><Name>lespinasse (new york city)</Name><Address>2 e. 55th st.</Address><City>new york city</City><Cuisine>asian</Cuisine><Cluster>43</Cluster></Restaurant>
<Restaurant><Name>lutece</Name><Address>249 e. 50th st.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>44</Cluster></Restaurant>
<Restaurant><Name>lutece</Name><Address>249 e. 50th st.</Address><City>new york city</City><Cuisine>french (classic)</Cuisine><Cluster>44</Cluster></Restaurant>
<Restaurant><Name>manhattan ocean club</Name><Address>57 w. 58th st.</Address><City>new york</City><Cuisine>seafood</Cuisine><Cluster>45</Cluster></Restaurant>
<Restaurant><Name>manhattan ocean club</Name><Address>57 w. 58th st.</Address><City>new york city</City><Cuisine>seafood</Cuisine><Cluster>45</Cluster></Restaurant>
<Restaurant><Name>march</Name><Address>405 e. 58th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>46</Cluster></Restaurant>
<Restaurant><Name>march</Name><Address>405 e. 58th st.</Address><City>new york city</City><Cuisine>american (new)</Cuisine><Cluster>46</Cluster></Restaurant>
<Restaurant><Name>mesa grill</Name><Address>102 5th ave.  between 15th and 16th sts.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>47</Cluster></Restaurant>
<Restaurant><Name>mesa grill</Name><Address>102 fifth ave.</Address><City>new york city</City><Cuisine>southwestern</Cuisine><Cluster>47</Cluster></Restaurant>
<Restaurant><Name>mi cocina</Name><Address>57 jane st.  off hudson st.</Address><City>new york</City><Cuisine>mexican</Cuisine><Cluster>48</Cluster></Restaurant>
<Restaurant><Name>mi cocina</Name><Address>57 jane st.</Address><City>new york city</City><Cuisine>mexican</Cuisine><Cluster>48</Cluster></Restaurant>
<Restaurant><Name>montrachet</Name><Address>239 w. broadway  between walker and white sts.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>49</Cluster></Restaurant>
<Restaurant><Name>montrachet</Name><Address>239 w. broadway</Address><City>new york city</City><Cuisine>french bistro</Cuisine><Cluster>49</Cluster></Restaurant>
<Restaurant><Name>oceana</Name><Address>55 e. 54th st.</Address><City>new york</City><Cuisine>seafood</Cuisine><Cluster>50</Cluster></Restaurant>
<Restaurant><Name>oceana</Name><Address>55 e. 54th st.</Address><City>new york city</City><Cuisine>seafood</Cuisine><Cluster>50</Cluster></Restaurant>
<Restaurant><Name>park avenue cafe</Name><Address>100 e. 63rd st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>51</Cluster></Restaurant>
<Restaurant><Name>park avenue cafe (new york city)</Name><Address>100 e. 63rd st.</Address><City>new york city</City><Cuisine>american (new)</Cuisine><Cluster>51</Cluster></Restaurant>
<Restaurant><Name>petrossian</Name><Address>182 w. 58th st.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>52</Cluster></Restaurant>
<Restaurant><Name>petrossian</Name><Address>182 w. 58th st.</Address><City>new york city</City><Cuisine>russian</Cuisine><Cluster>52</Cluster></Restaurant>
<Restaurant><Name>picholine</Name><Address>35 w. 64th st.</Address><City>new york</City><Cuisine>mediterranean</Cuisine><Cluster>53</Cluster></Restaurant>
<Restaurant><Name>picholine</Name><Address>35 w. 64th st.</Address><City>new york city</City><Cuisine>mediterranean</Cuisine><Cluster>53</Cluster></Restaurant>
<Restaurant><Name>pisces</Name><Address>95 ave. a at 6th st.</Address><City>new york</City><Cuisine>seafood</Cuisine><Cluster>54</Cluster></Restaurant>
<Restaurant><Name>pisces</Name><Address>95 ave. a</Address><City>new york city</City><Cuisine>seafood</Cuisine><Cluster>54</Cluster></Restaurant>
<Restaurant><Name>rainbow room</Name><Address>30 rockefeller plaza</Address><City>new york</City><Cuisine>or 212/632-5100 american</Cuisine><Cluster>55</Cluster></Restaurant>
<Restaurant><Name>rainbow room</Name><Address>30 rockefeller plaza</Address><City>new york city</City><Cuisine>american (new)</Cuisine><Cluster>55</Cluster></Restaurant>
<Restaurant><Name>river cafe</Name><Address>1 water st. at the east river</Address><City>brooklyn</City><Cuisine>american</Cuisine><Cluster>56</Cluster></Restaurant>
<Restaurant><Name>river cafe</Name><Address>1 water st.</Address><City>brooklyn</City><Cuisine>american (new)</Cuisine><Cluster>56</Cluster></Restaurant>
<Restaurant><Name>san domenico</Name><Address>240 central park s</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>57</Cluster></Restaurant>
<Restaurant><Name>san domenico</Name><Address>240 central park s.</Address><City>new york city</City><Cuisine>italian</Cuisine><Cluster>57</Cluster></Restaurant>
<Restaurant><Name>second avenue deli</Name><Address>156 2nd ave. at 10th st.</Address><City>new york</City><Cuisine>delicatessen</Cuisine><Cluster>58</Cluster></Restaurant>
<Restaurant><Name>second avenue deli</Name><Address>156 second ave.</Address><City>new york city</City><Cuisine>delis</Cuisine><Cluster>58</Cluster></Restaurant>
<Restaurant><Name>seryna</Name><Address>11 e. 53rd st.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>59</Cluster></Restaurant>
<Restaurant><Name>seryna</Name><Address>11 e. 53rd st.</Address><City>new york city</City><Cuisine>japanese</Cuisine><Cluster>59</Cluster></Restaurant>
<Restaurant><Name>shun lee west</Name><Address>43 w. 65th st.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>60</Cluster></Restaurant>
<Restaurant><Name>shun lee palace</Name><Address>155 e. 55th st.</Address><City>new york city</City><Cuisine>chinese</Cuisine><Cluster>60</Cluster></Restaurant>
<Restaurant><Name>sign of the dove</Name><Address>1110 3rd ave. at 65th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>61</Cluster></Restaurant>
<Restaurant><Name>sign of the dove</Name><Address>1110 third ave.</Address><City>new york city</City><Cuisine>american (new)</Cuisine><Cluster>61</Cluster></Restaurant>
<Restaurant><Name><![CDATA[smith & wollensky]]></Name><Address>201 e. 49th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>62</Cluster></Restaurant>
<Restaurant><Name><![CDATA[smith & wollensky]]></Name><Address>797 third ave.</Address><City>new york city</City><Cuisine>steakhouses</Cuisine><Cluster>62</Cluster></Restaurant>
<Restaurant><Name>tavern on the green</Name><Address>in central park at 67th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>63</Cluster></Restaurant>
<Restaurant><Name>tavern on the green</Name><Address>central park west</Address><City>new york city</City><Cuisine>american (new)</Cuisine><Cluster>63</Cluster></Restaurant>
<Restaurant><Name>uncle nick's</Name><Address>747 9th ave.  between 50th and 51st sts.</Address><City>new york</City><Cuisine>mediterranean</Cuisine><Cluster>64</Cluster></Restaurant>
<Restaurant><Name>uncle nick's</Name><Address>747 ninth ave.</Address><City>new york city</City><Cuisine>greek</Cuisine><Cluster>64</Cluster></Restaurant>
<Restaurant><Name>union square cafe</Name><Address>21 e. 16th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>65</Cluster></Restaurant>
<Restaurant><Name>union square cafe</Name><Address>21 e. 16th st.</Address><City>new york city</City><Cuisine>american (new)</Cuisine><Cluster>65</Cluster></Restaurant>
<Restaurant><Name>virgil's</Name><Address>152 w. 44th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>66</Cluster></Restaurant>
<Restaurant><Name>virgil's real bbq</Name><Address>152 w. 44th st.</Address><City>new york city</City><Cuisine>bbq</Cuisine><Cluster>66</Cluster></Restaurant>
<Restaurant><Name>chin's</Name><Address>3200 las vegas blvd. s</Address><City>las vegas</City><Cuisine>asian</Cuisine><Cluster>67</Cluster></Restaurant>
<Restaurant><Name>chin's</Name><Address>3200 las vegas blvd. s.</Address><City>las vegas</City><Cuisine>chinese</Cuisine><Cluster>67</Cluster></Restaurant>
<Restaurant><Name>coyote cafe</Name><Address>3799 las vegas blvd. s</Address><City>las vegas</City><Cuisine>southwestern</Cuisine><Cluster>68</Cluster></Restaurant>
<Restaurant><Name>coyote cafe (las vegas)</Name><Address>3799 las vegas blvd. s.</Address><City>las vegas</City><Cuisine>southwestern</Cuisine><Cluster>68</Cluster></Restaurant>
<Restaurant><Name>le montrachet</Name><Address>3000 w. paradise rd.</Address><City>las vegas</City><Cuisine>continental</Cuisine><Cluster>69</Cluster></Restaurant>
<Restaurant><Name>le montrachet bistro</Name><Address>3000 paradise rd.</Address><City>las vegas</City><Cuisine>french bistro</Cuisine><Cluster>69</Cluster></Restaurant>
<Restaurant><Name>palace court</Name><Address>3570 las vegas blvd. s</Address><City>las vegas</City><Cuisine>continental</Cuisine><Cluster>70</Cluster></Restaurant>
<Restaurant><Name>palace court</Name><Address>3570 las vegas blvd. s.</Address><City>las vegas</City><Cuisine>french (new)</Cuisine><Cluster>70</Cluster></Restaurant>
<Restaurant><Name>second street grille</Name><Address>200 e. fremont st.</Address><City>las vegas</City><Cuisine>seafood</Cuisine><Cluster>71</Cluster></Restaurant>
<Restaurant><Name>second street grill</Name><Address>200 e. fremont st.</Address><City>las vegas</City><Cuisine>pacific rim</Cuisine><Cluster>71</Cluster></Restaurant>
<Restaurant><Name>steak house</Name><Address>2880 las vegas blvd. s</Address><City>las vegas</City><Cuisine>steak houses</Cuisine><Cluster>72</Cluster></Restaurant>
<Restaurant><Name>steak house  the</Name><Address>2880 las vegas blvd. s.</Address><City>las vegas</City><Cuisine>steakhouses</Cuisine><Cluster>72</Cluster></Restaurant>
<Restaurant><Name>tillerman</Name><Address>2245 e. flamingo rd.</Address><City>las vegas</City><Cuisine>seafood</Cuisine><Cluster>73</Cluster></Restaurant>
<Restaurant><Name>tillerman  the</Name><Address>2245 e. flamingo rd.</Address><City>las vegas</City><Cuisine>steakhouses</Cuisine><Cluster>73</Cluster></Restaurant>
<Restaurant><Name>abruzzi</Name><Address>2355 peachtree rd. ne</Address><City>atlanta</City><Cuisine>italian</Cuisine><Cluster>74</Cluster></Restaurant>
<Restaurant><Name>bacchanalia</Name><Address>3125 piedmont rd.  near peachtree rd.</Address><City>atlanta</City><Cuisine>international</Cuisine><Cluster>75</Cluster></Restaurant>
<Restaurant><Name>bacchanalia</Name><Address>3125 piedmont rd.</Address><City>atlanta</City><Cuisine>californian</Cuisine><Cluster>75</Cluster></Restaurant>
<Restaurant><Name>bone's</Name><Address>3130 piedmont road</Address><City>atlanta</City><Cuisine>american</Cuisine><Cluster>76</Cluster></Restaurant>
<Restaurant><Name>bone's restaurant</Name><Address>3130 piedmont rd. ne</Address><City>atlanta</City><Cuisine>steakhouses</Cuisine><Cluster>76</Cluster></Restaurant>
<Restaurant><Name>brasserie le coze</Name><Address>3393 peachtree rd.</Address><City>atlanta</City><Cuisine>french bistro</Cuisine><Cluster>77</Cluster></Restaurant>
<Restaurant><Name>buckhead diner</Name><Address>3073 piedmont road</Address><City>atlanta</City><Cuisine>american</Cuisine><Cluster>78</Cluster></Restaurant>
<Restaurant><Name>buckhead diner</Name><Address>3073 piedmont rd.</Address><City>atlanta</City><Cuisine>american (new)</Cuisine><Cluster>78</Cluster></Restaurant>
<Restaurant><Name>ciboulette</Name><Address>1529 piedmont ave.</Address><City>atlanta</City><Cuisine>french</Cuisine><Cluster>79</Cluster></Restaurant>
<Restaurant><Name>ciboulette restaurant</Name><Address>1529 piedmont ave.</Address><City>atlanta</City><Cuisine>french (new)</Cuisine><Cluster>79</Cluster></Restaurant>
<Restaurant><Name>delectables</Name><Address>1 margaret mitchell sq.</Address><City>atlanta</City><Cuisine>american</Cuisine><Cluster>80</Cluster></Restaurant>
<Restaurant><Name>delectables</Name><Address>1 margaret mitchell sq.</Address><City>atlanta</City><Cuisine>cafeterias</Cuisine><Cluster>80</Cluster></Restaurant>
<Restaurant><Name>georgia grille</Name><Address>2290 peachtree rd.</Address><City>atlanta</City><Cuisine>southwestern</Cuisine><Cluster>81</Cluster></Restaurant>
<Restaurant><Name>hedgerose heights inn</Name><Address>490 e. paces ferry rd.</Address><City>atlanta</City><Cuisine>international</Cuisine><Cluster>82</Cluster></Restaurant>
<Restaurant><Name>hedgerose heights inn  the</Name><Address>490 e. paces ferry rd. ne</Address><City>atlanta</City><Cuisine>continental</Cuisine><Cluster>82</Cluster></Restaurant>
<Restaurant><Name>heera of india</Name><Address>595 piedmont ave.  rio shopping mall</Address><City>atlanta</City><Cuisine>asian</Cuisine><Cluster>83</Cluster></Restaurant>
<Restaurant><Name>heera of india</Name><Address>595 piedmont ave.</Address><City>atlanta</City><Cuisine>indian</Cuisine><Cluster>83</Cluster></Restaurant>
<Restaurant><Name>indigo coastal grill</Name><Address>1397 n. highland ave.</Address><City>atlanta</City><Cuisine>caribbean</Cuisine><Cluster>84</Cluster></Restaurant>
<Restaurant><Name>indigo coastal grill</Name><Address>1397 n. highland ave.</Address><City>atlanta</City><Cuisine>eclectic</Cuisine><Cluster>84</Cluster></Restaurant>
<Restaurant><Name>la grotta</Name><Address>2637 peachtree rd.  peachtree house condominium</Address><City>atlanta</City><Cuisine>italian</Cuisine><Cluster>85</Cluster></Restaurant>
<Restaurant><Name>la grotta</Name><Address>2637 peachtree rd. ne</Address><City>atlanta</City><Cuisine>italian</Cuisine><Cluster>85</Cluster></Restaurant>
<Restaurant><Name>mary mac's tea room</Name><Address>224 ponce de leon ave.</Address><City>atlanta</City><Cuisine>southern</Cuisine><Cluster>86</Cluster></Restaurant>
<Restaurant><Name>mary mac's tea room</Name><Address>224 ponce de leon ave.</Address><City>atlanta</City><Cuisine>southern/soul</Cuisine><Cluster>86</Cluster></Restaurant>
<Restaurant><Name>nikolai's roof</Name><Address>255 courtland st.  at harris st.</Address><City>atlanta</City><Cuisine>continental</Cuisine><Cluster>87</Cluster></Restaurant>
<Restaurant><Name>nikolai's roof</Name><Address>255 courtland st.</Address><City>atlanta</City><Cuisine>continental</Cuisine><Cluster>87</Cluster></Restaurant>
<Restaurant><Name>pano's and paul's</Name><Address>1232 w. paces ferry rd.</Address><City>atlanta</City><Cuisine>international</Cuisine><Cluster>88</Cluster></Restaurant>
<Restaurant><Name><![CDATA[pano's & paul's]]></Name><Address>1232 w. paces ferry rd.</Address><City>atlanta</City><Cuisine>american (new)</Cuisine><Cluster>88</Cluster></Restaurant>
<Restaurant><Name>cafe  ritz-carlton  buckhead</Name><Address>3434 peachtree rd.</Address><City>atlanta</City><Cuisine>ext 6108 international</Cuisine><Cluster>89</Cluster></Restaurant>
<Restaurant><Name>ritz-carlton cafe (buckhead)</Name><Address>3434 peachtree rd. ne</Address><City>atlanta</City><Cuisine>american (new)</Cuisine><Cluster>89</Cluster></Restaurant>
<Restaurant><Name>dining room  ritz-carlton  buckhead</Name><Address>3434 peachtree rd.</Address><City>atlanta</City><Cuisine>international</Cuisine><Cluster>90</Cluster></Restaurant>
<Restaurant><Name>ritz-carlton dining room (buckhead)</Name><Address>3434 peachtree rd. ne</Address><City>atlanta</City><Cuisine>american (new)</Cuisine><Cluster>90</Cluster></Restaurant>
<Restaurant><Name>restaurant  ritz-carlton  atlanta</Name><Address>181 peachtree st.</Address><City>atlanta</City><Cuisine>continental</Cuisine><Cluster>91</Cluster></Restaurant>
<Restaurant><Name>ritz-carlton restaurant</Name><Address>181 peachtree st.</Address><City>atlanta</City><Cuisine>french (classic)</Cuisine><Cluster>91</Cluster></Restaurant>
<Restaurant><Name>toulouse</Name><Address>b peachtree rd.</Address><City>atlanta</City><Cuisine>french</Cuisine><Cluster>92</Cluster></Restaurant>
<Restaurant><Name>toulouse</Name><Address>293-b peachtree rd.</Address><City>atlanta</City><Cuisine>french (new)</Cuisine><Cluster>92</Cluster></Restaurant>
<Restaurant><Name>veni vidi vici</Name><Address>41 14th st.</Address><City>atlanta</City><Cuisine>italian</Cuisine><Cluster>93</Cluster></Restaurant>
<Restaurant><Name>veni vidi vici</Name><Address>41 14th st.</Address><City>atlanta</City><Cuisine>italian</Cuisine><Cluster>93</Cluster></Restaurant>
<Restaurant><Name>alain rondelli</Name><Address>126 clement st.</Address><City>san francisco</City><Cuisine>french</Cuisine><Cluster>94</Cluster></Restaurant>
<Restaurant><Name>alain rondelli</Name><Address>126 clement st.</Address><City>san francisco</City><Cuisine>french (new)</Cuisine><Cluster>94</Cluster></Restaurant>
<Restaurant><Name>aqua</Name><Address>252 california st.</Address><City>san francisco</City><Cuisine>seafood</Cuisine><Cluster>95</Cluster></Restaurant>
<Restaurant><Name>aqua</Name><Address>252 california st.</Address><City>san francisco</City><Cuisine>american (new)</Cuisine><Cluster>95</Cluster></Restaurant>
<Restaurant><Name>boulevard</Name><Address>1 mission st.</Address><City>san francisco</City><Cuisine>american</Cuisine><Cluster>96</Cluster></Restaurant>
<Restaurant><Name>boulevard</Name><Address>1 mission st.</Address><City>san francisco</City><Cuisine>american (new)</Cuisine><Cluster>96</Cluster></Restaurant>
<Restaurant><Name>cafe claude</Name><Address>7 claude la.</Address><City>san francisco</City><Cuisine>french</Cuisine><Cluster>97</Cluster></Restaurant>
<Restaurant><Name>cafe claude</Name><Address>7 claude ln.</Address><City>san francisco</City><Cuisine>french bistro</Cuisine><Cluster>97</Cluster></Restaurant>
<Restaurant><Name>campton place</Name><Address>340 stockton st.</Address><City>san francisco</City><Cuisine>american</Cuisine><Cluster>98</Cluster></Restaurant>
<Restaurant><Name>campton place</Name><Address>340 stockton st.</Address><City>san francisco</City><Cuisine>american (new)</Cuisine><Cluster>98</Cluster></Restaurant>
<Restaurant><Name>chez michel</Name><Address>804 northpoint</Address><City>san francisco</City><Cuisine>french</Cuisine><Cluster>99</Cluster></Restaurant>
<Restaurant><Name>chez michel</Name><Address>804 north point st.</Address><City>san francisco</City><Cuisine>californian</Cuisine><Cluster>99</Cluster></Restaurant>
<Restaurant><Name>fleur de lys</Name><Address>777 sutter st.</Address><City>san francisco</City><Cuisine>french</Cuisine><Cluster>100</Cluster></Restaurant>
<Restaurant><Name>fleur de lys</Name><Address>777 sutter st.</Address><City>san francisco</City><Cuisine>french (new)</Cuisine><Cluster>100</Cluster></Restaurant>
<Restaurant><Name>fringale</Name><Address>570 4th st.</Address><City>san francisco</City><Cuisine>french</Cuisine><Cluster>101</Cluster></Restaurant>
<Restaurant><Name>fringale</Name><Address>570 fourth st.</Address><City>san francisco</City><Cuisine>french bistro</Cuisine><Cluster>101</Cluster></Restaurant>
<Restaurant><Name>hawthorne lane</Name><Address>22 hawthorne st.</Address><City>san francisco</City><Cuisine>american</Cuisine><Cluster>102</Cluster></Restaurant>
<Restaurant><Name>hawthorne lane</Name><Address>22 hawthorne st.</Address><City>san francisco</City><Cuisine>californian</Cuisine><Cluster>102</Cluster></Restaurant>
<Restaurant><Name>khan toke thai house</Name><Address>5937 geary blvd.</Address><City>san francisco</City><Cuisine>asian</Cuisine><Cluster>103</Cluster></Restaurant>
<Restaurant><Name>khan toke thai house</Name><Address>5937 geary blvd.</Address><City>san francisco</City><Cuisine>thai</Cuisine><Cluster>103</Cluster></Restaurant>
<Restaurant><Name>la folie</Name><Address>2316 polk st.</Address><City>san francisco</City><Cuisine>french</Cuisine><Cluster>104</Cluster></Restaurant>
<Restaurant><Name>la folie</Name><Address>2316 polk st.</Address><City>san francisco</City><Cuisine>french (new)</Cuisine><Cluster>104</Cluster></Restaurant>
<Restaurant><Name>lulu</Name><Address>816 folsom st.</Address><City>san francisco</City><Cuisine>mediterranean</Cuisine><Cluster>105</Cluster></Restaurant>
<Restaurant><Name>lulu restaurant-bis-cafe</Name><Address>816 folsom st.</Address><City>san francisco</City><Cuisine>mediterranean</Cuisine><Cluster>105</Cluster></Restaurant>
<Restaurant><Name>masa's</Name><Address>648 bush st.</Address><City>san francisco</City><Cuisine>french</Cuisine><Cluster>106</Cluster></Restaurant>
<Restaurant><Name>masa's</Name><Address>648 bush st.</Address><City>san francisco</City><Cuisine>french (new)</Cuisine><Cluster>106</Cluster></Restaurant>
<Restaurant><Name>mifune japan center  kintetsu building</Name><Address>1737 post st.</Address><City>san francisco</City><Cuisine>asian</Cuisine><Cluster>107</Cluster></Restaurant>
<Restaurant><Name>mifune</Name><Address>1737 post st.</Address><City>san francisco</City><Cuisine>japanese</Cuisine><Cluster>107</Cluster></Restaurant>
<Restaurant><Name>plumpjack cafe</Name><Address>3201 fillmore st.</Address><City>san francisco</City><Cuisine>mediterranean</Cuisine><Cluster>108</Cluster></Restaurant>
<Restaurant><Name>plumpjack cafe</Name><Address>3127 fillmore st.</Address><City>san francisco</City><Cuisine>american (new)</Cuisine><Cluster>108</Cluster></Restaurant>
<Restaurant><Name>postrio</Name><Address>545 post st.</Address><City>san francisco</City><Cuisine>american</Cuisine><Cluster>109</Cluster></Restaurant>
<Restaurant><Name>postrio</Name><Address>545 post st.</Address><City>san francisco</City><Cuisine>californian</Cuisine><Cluster>109</Cluster></Restaurant>
<Restaurant><Name>ritz-carlton restaurant and dining room</Name><Address>600 stockton st.</Address><City>san francisco</City><Cuisine>american</Cuisine><Cluster>110</Cluster></Restaurant>
<Restaurant><Name>ritz-carlton dining room (san francisco)</Name><Address>600 stockton st.</Address><City>san francisco</City><Cuisine>french (new)</Cuisine><Cluster>110</Cluster></Restaurant>
<Restaurant><Name>rose pistola</Name><Address>532 columbus ave.</Address><City>san francisco</City><Cuisine>italian</Cuisine><Cluster>111</Cluster></Restaurant>
<Restaurant><Name>rose pistola</Name><Address>532 columbus ave.</Address><City>san francisco</City><Cuisine>italian</Cuisine><Cluster>111</Cluster></Restaurant>
<Restaurant><Name>adriano's ristorante</Name><Address>2930 beverly glen circle</Address><City>los angeles</City><Cuisine>italian</Cuisine><Cluster>112</Cluster></Restaurant>
<Restaurant><Name>barney greengrass</Name><Address>9570 wilshire blvd.</Address><City>beverly hills</City><Cuisine>american</Cuisine><Cluster>113</Cluster></Restaurant>
<Restaurant><Name>beaurivage</Name><Address>26025 pacific coast hwy.</Address><City>malibu</City><Cuisine>french</Cuisine><Cluster>114</Cluster></Restaurant>
<Restaurant><Name>bistro garden</Name><Address>176 n. canon dr.</Address><City>los angeles</City><Cuisine>californian</Cuisine><Cluster>115</Cluster></Restaurant>
<Restaurant><Name>border grill</Name><Address>4th st.</Address><City>los angeles</City><Cuisine>mexican</Cuisine><Cluster>116</Cluster></Restaurant>
<Restaurant><Name>broadway deli</Name><Address>3rd st. promenade</Address><City>santa monica</City><Cuisine>american</Cuisine><Cluster>117</Cluster></Restaurant>
<Restaurant><Name>ca'brea</Name><Address>346 s. la brea ave.</Address><City>los angeles</City><Cuisine>italian</Cuisine><Cluster>118</Cluster></Restaurant>
<Restaurant><Name>ca'del sol</Name><Address>4100 cahuenga blvd.</Address><City>los angeles</City><Cuisine>italian</Cuisine><Cluster>119</Cluster></Restaurant>
<Restaurant><Name>cafe pinot</Name><Address>700 w. fifth st.</Address><City>los angeles</City><Cuisine>californian</Cuisine><Cluster>120</Cluster></Restaurant>
<Restaurant><Name>california pizza kitchen</Name><Address>207 s. beverly dr.</Address><City>los angeles</City><Cuisine>californian</Cuisine><Cluster>121</Cluster></Restaurant>
<Restaurant><Name>canter's</Name><Address>419 n. fairfax ave.</Address><City>los angeles</City><Cuisine>american</Cuisine><Cluster>122</Cluster></Restaurant>
<Restaurant><Name>cava</Name><Address>3rd st.</Address><City>los angeles</City><Cuisine>mediterranean</Cuisine><Cluster>123</Cluster></Restaurant>
<Restaurant><Name>cha cha cha</Name><Address>656 n. virgil ave.</Address><City>los angeles</City><Cuisine>caribbean</Cuisine><Cluster>124</Cluster></Restaurant>
<Restaurant><Name>chan dara</Name><Address>310 n. larchmont blvd.</Address><City>los angeles</City><Cuisine>asian</Cuisine><Cluster>125</Cluster></Restaurant>
<Restaurant><Name>clearwater cafe</Name><Address>168 w. colorado blvd.</Address><City>los angeles</City><Cuisine>health food</Cuisine><Cluster>126</Cluster></Restaurant>
<Restaurant><Name>dining room</Name><Address>9500 wilshire blvd.</Address><City>los angeles</City><Cuisine>californian</Cuisine><Cluster>127</Cluster></Restaurant>
<Restaurant><Name>dive!</Name><Address>10250 santa monica blvd.</Address><City>los angeles</City><Cuisine>dive american</Cuisine><Cluster>128</Cluster></Restaurant>
<Restaurant><Name>drago</Name><Address>2628 wilshire blvd.</Address><City>santa monica</City><Cuisine>italian</Cuisine><Cluster>129</Cluster></Restaurant>
<Restaurant><Name>drai's</Name><Address>730 n. la cienega blvd.</Address><City>los angeles</City><Cuisine>french</Cuisine><Cluster>130</Cluster></Restaurant>
<Restaurant><Name>dynasty room</Name><Address>930 hilgard ave.</Address><City>los angeles</City><Cuisine>continental</Cuisine><Cluster>131</Cluster></Restaurant>
<Restaurant><Name>eclipse</Name><Address>8800 melrose ave.</Address><City>los angeles</City><Cuisine>californian</Cuisine><Cluster>132</Cluster></Restaurant>
<Restaurant><Name>ed debevic's</Name><Address>134 n. la cienega</Address><City>los angeles</City><Cuisine>american</Cuisine><Cluster>133</Cluster></Restaurant>
<Restaurant><Name>el cholo</Name><Address>1121 s. western ave.</Address><City>los angeles</City><Cuisine>mexican</Cuisine><Cluster>134</Cluster></Restaurant>
<Restaurant><Name>gilliland's</Name><Address>2424 main st.</Address><City>santa monica</City><Cuisine>american</Cuisine><Cluster>135</Cluster></Restaurant>
<Restaurant><Name>gladstone's</Name><Address>4 fish 17300 pacific coast hwy. at sunset blvd.</Address><City>pacific palisades</City><Cuisine>american</Cuisine><Cluster>136</Cluster></Restaurant>
<Restaurant><Name>hard rock cafe</Name><Address>8600 beverly blvd.</Address><City>los angeles</City><Cuisine>american</Cuisine><Cluster>137</Cluster></Restaurant>
<Restaurant><Name><![CDATA[harry's bar & american grill]]></Name><Address>2020 ave. of the stars</Address><City>los angeles</City><Cuisine>italian</Cuisine><Cluster>138</Cluster></Restaurant>
<Restaurant><Name>il fornaio cucina italiana</Name><Address>301 n. beverly dr.</Address><City>los angeles</City><Cuisine>italian</Cuisine><Cluster>139</Cluster></Restaurant>
<Restaurant><Name>jack sprat's grill</Name><Address>10668 w. pico blvd.</Address><City>los angeles</City><Cuisine>health food</Cuisine><Cluster>140</Cluster></Restaurant>
<Restaurant><Name>jackson's farm</Name><Address>439 n. beverly drive</Address><City>los angeles</City><Cuisine>californian</Cuisine><Cluster>141</Cluster></Restaurant>
<Restaurant><Name>jimmy's</Name><Address>201 moreno dr.</Address><City>los angeles</City><Cuisine>continental</Cuisine><Cluster>142</Cluster></Restaurant>
<Restaurant><Name>joss</Name><Address>9255 sunset blvd.</Address><City>los angeles</City><Cuisine>asian</Cuisine><Cluster>143</Cluster></Restaurant>
<Restaurant><Name>le colonial</Name><Address>8783 beverly blvd.</Address><City>los angeles</City><Cuisine>asian</Cuisine><Cluster>144</Cluster></Restaurant>
<Restaurant><Name>le dome</Name><Address>8720 sunset blvd.</Address><City>los angeles</City><Cuisine>french</Cuisine><Cluster>145</Cluster></Restaurant>
<Restaurant><Name>louise's trattoria</Name><Address>4500 los feliz blvd.</Address><City>los angeles</City><Cuisine>italian</Cuisine><Cluster>146</Cluster></Restaurant>
<Restaurant><Name>mon kee seafood restaurant</Name><Address>679 n. spring st.</Address><City>los angeles</City><Cuisine>asian</Cuisine><Cluster>147</Cluster></Restaurant>
<Restaurant><Name>morton's</Name><Address>8764 melrose ave.</Address><City>los angeles</City><Cuisine>american</Cuisine><Cluster>148</Cluster></Restaurant>
<Restaurant><Name>nate 'n' al's</Name><Address>414 n. beverly dr.</Address><City>los angeles</City><Cuisine>american</Cuisine><Cluster>149</Cluster></Restaurant>
<Restaurant><Name>nicola</Name><Address>601 s. figueroa st.</Address><City>los angeles</City><Cuisine>american</Cuisine><Cluster>150</Cluster></Restaurant>
<Restaurant><Name>ocean avenue</Name><Address>1401 ocean ave.</Address><City>santa monica</City><Cuisine>american</Cuisine><Cluster>151</Cluster></Restaurant>
<Restaurant><Name>orleans</Name><Address>11705 national blvd.</Address><City>los angeles</City><Cuisine>cajun</Cuisine><Cluster>152</Cluster></Restaurant>
<Restaurant><Name>pacific dining car</Name><Address>6th st.</Address><City>los angeles</City><Cuisine>american</Cuisine><Cluster>153</Cluster></Restaurant>
<Restaurant><Name>paty's</Name><Address>10001 riverside dr.</Address><City>toluca lake</City><Cuisine>american</Cuisine><Cluster>154</Cluster></Restaurant>
<Restaurant><Name>pinot hollywood</Name><Address>1448 n. gower st.</Address><City>los angeles</City><Cuisine>californian</Cuisine><Cluster>155</Cluster></Restaurant>
<Restaurant><Name>posto</Name><Address>14928 ventura blvd.</Address><City>sherman oaks</City><Cuisine>italian</Cuisine><Cluster>156</Cluster></Restaurant>
<Restaurant><Name>prego</Name><Address>362 n. camden dr.</Address><City>los angeles</City><Cuisine>italian</Cuisine><Cluster>157</Cluster></Restaurant>
<Restaurant><Name>rj's the rib joint</Name><Address>252 n. beverly dr.</Address><City>los angeles</City><Cuisine>american</Cuisine><Cluster>158</Cluster></Restaurant>
<Restaurant><Name>remi</Name><Address>3rd st. promenade</Address><City>santa monica</City><Cuisine>italian</Cuisine><Cluster>159</Cluster></Restaurant>
<Restaurant><Name>restaurant horikawa</Name><Address>111 s. san pedro st.</Address><City>los angeles</City><Cuisine>asian</Cuisine><Cluster>160</Cluster></Restaurant>
<Restaurant><Name>roscoe's house of chicken 'n' waffles</Name><Address>1514 n. gower st.</Address><City>los angeles</City><Cuisine>american</Cuisine><Cluster>161</Cluster></Restaurant>
<Restaurant><Name>schatzi on main</Name><Address>3110 main st.</Address><City>los angeles</City><Cuisine>continental</Cuisine><Cluster>162</Cluster></Restaurant>
<Restaurant><Name>sofi</Name><Address>3rd st.</Address><City>los angeles</City><Cuisine>mediterranean</Cuisine><Cluster>163</Cluster></Restaurant>
<Restaurant><Name>swingers</Name><Address>8020 beverly blvd.</Address><City>los angeles</City><Cuisine>american</Cuisine><Cluster>164</Cluster></Restaurant>
<Restaurant><Name>tavola calda</Name><Address>7371 melrose ave.</Address><City>los angeles</City><Cuisine>italian</Cuisine><Cluster>165</Cluster></Restaurant>
<Restaurant><Name>the mandarin</Name><Address>430 n. camden dr.</Address><City>los angeles</City><Cuisine>asian</Cuisine><Cluster>166</Cluster></Restaurant>
<Restaurant><Name>tommy tang's</Name><Address>7313 melrose ave.</Address><City>los angeles</City><Cuisine>asian</Cuisine><Cluster>167</Cluster></Restaurant>
<Restaurant><Name>tra di noi</Name><Address>3835 cross creek rd.</Address><City>los angeles</City><Cuisine>italian</Cuisine><Cluster>168</Cluster></Restaurant>
<Restaurant><Name>trader vic's</Name><Address>9876 wilshire blvd.</Address><City>los angeles</City><Cuisine>asian</Cuisine><Cluster>169</Cluster></Restaurant>
<Restaurant><Name>vida</Name><Address>1930 north hillhurst ave.</Address><City>los feliz</City><Cuisine>american</Cuisine><Cluster>170</Cluster></Restaurant>
<Restaurant><Name>west beach cafe</Name><Address>60 n. venice blvd.</Address><City>los angeles</City><Cuisine>american</Cuisine><Cluster>171</Cluster></Restaurant>
<Restaurant><Name>20 mott</Name><Address>20 mott st.  between bowery and pell st.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>172</Cluster></Restaurant>
<Restaurant><Name>9 jones street</Name><Address>9 jones st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>173</Cluster></Restaurant>
<Restaurant><Name>adrienne</Name><Address>700 5th ave. at 55th st.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>174</Cluster></Restaurant>
<Restaurant><Name>agrotikon</Name><Address>322 e. 14 st.  between 1st and 2nd aves.</Address><City>new york</City><Cuisine>mediterranean</Cuisine><Cluster>175</Cluster></Restaurant>
<Restaurant><Name>aja</Name><Address>937 broadway at 22nd st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>176</Cluster></Restaurant>
<Restaurant><Name>alamo</Name><Address>304 e. 48th st.</Address><City>new york</City><Cuisine>mexican</Cuisine><Cluster>177</Cluster></Restaurant>
<Restaurant><Name>alley's end</Name><Address>311 w. 17th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>178</Cluster></Restaurant>
<Restaurant><Name>ambassador grill</Name><Address>1 united nations plaza at 44th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>179</Cluster></Restaurant>
<Restaurant><Name>american place</Name><Address>2 park ave. at 32nd st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>180</Cluster></Restaurant>
<Restaurant><Name>anche vivolo</Name><Address>222 e. 58th st.  between 2nd and 3rd aves.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>181</Cluster></Restaurant>
<Restaurant><Name>arizona</Name><Address>206 206 e. 60th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>182</Cluster></Restaurant>
<Restaurant><Name>arturo's</Name><Address>106 w. houston st.  off thompson st.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>183</Cluster></Restaurant>
<Restaurant><Name>au mandarin</Name><Address>200-250 vesey st. world financial center</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>184</Cluster></Restaurant>
<Restaurant><Name>bar anise</Name><Address>1022 3rd ave.  between 60th and 61st sts.</Address><City>new york</City><Cuisine>mediterranean</Cuisine><Cluster>185</Cluster></Restaurant>
<Restaurant><Name>barbetta</Name><Address>321 w. 46th st.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>186</Cluster></Restaurant>
<Restaurant><Name>ben benson's</Name><Address>123 w. 52nd st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>187</Cluster></Restaurant>
<Restaurant><Name>big cup</Name><Address>228 8th ave.  between 21st and 22nd sts.</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>188</Cluster></Restaurant>
<Restaurant><Name>billy's</Name><Address>948 1st ave.  between 52nd and 53rd sts.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>189</Cluster></Restaurant>
<Restaurant><Name>boca chica</Name><Address>13 1st ave.  near 1st st.</Address><City>new york</City><Cuisine>latin american</Cuisine><Cluster>190</Cluster></Restaurant>
<Restaurant><Name>bolo</Name><Address>23 e. 22nd st.</Address><City>new york</City><Cuisine>mediterranean</Cuisine><Cluster>191</Cluster></Restaurant>
<Restaurant><Name>boonthai</Name><Address>1393a 2nd ave.  between 72nd and 73rd sts.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>192</Cluster></Restaurant>
<Restaurant><Name>bouterin</Name><Address>420 e. 59th st.  off 1st ave.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>193</Cluster></Restaurant>
<Restaurant><Name>brothers bar-b-q</Name><Address>225 varick st. at clarkston st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>194</Cluster></Restaurant>
<Restaurant><Name>bruno</Name><Address>240 e. 58th st.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>195</Cluster></Restaurant>
<Restaurant><Name>bryant park grill  roof restaurant and bp cafe</Name><Address>25 w. 40th st.  between 5th and 6th aves.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>196</Cluster></Restaurant>
<Restaurant><Name>c3</Name><Address>103 waverly pl.  near washington sq.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>197</Cluster></Restaurant>
<Restaurant><Name>cafe bianco</Name><Address>1486 2nd ave.  between 77th and 78th sts.</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>199</Cluster></Restaurant>
<Restaurant><Name>cafe botanica</Name><Address>160 central park s</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>200</Cluster></Restaurant>
<Restaurant><Name>cafe la fortuna</Name><Address>69 w. 71st st.</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>201</Cluster></Restaurant>
<Restaurant><Name>cafe luxembourg</Name><Address>200 w. 70th st.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>202</Cluster></Restaurant>
<Restaurant><Name>cafe pierre</Name><Address>2 e. 61st st.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>203</Cluster></Restaurant>
<Restaurant><Name>cafe fes</Name><Address>246 w. 4th st. at charles st.</Address><City>new york</City><Cuisine>mediterranean</Cuisine><Cluster>205</Cluster></Restaurant>
<Restaurant><Name>caffe dante</Name><Address>81 macdougal st.  between houston and bleeker sts.</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>206</Cluster></Restaurant>
<Restaurant><Name>caffe dell'artista</Name><Address>46 greenwich ave.</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>207</Cluster></Restaurant>
<Restaurant><Name>caffe reggio</Name><Address>119 macdougal st.  between 3rd and bleecker sts.</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>209</Cluster></Restaurant>
<Restaurant><Name>caffe roma</Name><Address>385 broome st. at mulberry</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>210</Cluster></Restaurant>
<Restaurant><Name>caffe vivaldi</Name><Address>32 jones st. at bleecker st.</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>211</Cluster></Restaurant>
<Restaurant><Name>caffe bondi ristorante</Name><Address>7 w. 20th st.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>212</Cluster></Restaurant>
<Restaurant><Name>capsouto freres</Name><Address>451 washington st.  near watts st.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>213</Cluster></Restaurant>
<Restaurant><Name>captain's table</Name><Address>860 2nd ave. at 46th st.</Address><City>new york</City><Cuisine>seafood</Cuisine><Cluster>214</Cluster></Restaurant>
<Restaurant><Name>casa la femme</Name><Address>150 wooster st.  between houston and prince sts.</Address><City>new york</City><Cuisine>middle eastern</Cuisine><Cluster>215</Cluster></Restaurant>
<Restaurant><Name><![CDATA[cendrillon asian grill & marimba bar]]></Name><Address>45 mercer st.  between broome and grand sts.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>216</Cluster></Restaurant>
<Restaurant><Name>chiam</Name><Address>160 e. 48th st.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>218</Cluster></Restaurant>
<Restaurant><Name>china grill</Name><Address>60 w. 53rd st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>219</Cluster></Restaurant>
<Restaurant><Name>cite</Name><Address>120 w. 51st st.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>220</Cluster></Restaurant>
<Restaurant><Name>coco pazzo</Name><Address>23 e. 74th st.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>221</Cluster></Restaurant>
<Restaurant><Name>columbus bakery</Name><Address>53rd sts.</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>222</Cluster></Restaurant>
<Restaurant><Name>corrado cafe</Name><Address>1013 3rd ave.  between 60th and 61st sts.</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>223</Cluster></Restaurant>
<Restaurant><Name>cupcake cafe</Name><Address>522 9th ave. at 39th st.</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>224</Cluster></Restaurant>
<Restaurant><Name>da nico</Name><Address>164 mulberry st.  between grand and broome sts.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>225</Cluster></Restaurant>
<Restaurant><Name><![CDATA[dean & deluca]]></Name><Address>121 prince st.</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>226</Cluster></Restaurant>
<Restaurant><Name>diva</Name><Address>341 w. broadway  near grand st.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>227</Cluster></Restaurant>
<Restaurant><Name>dix et sept</Name><Address>181 w. 10th st.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>228</Cluster></Restaurant>
<Restaurant><Name>docks</Name><Address>633 3rd ave. at 40th st.</Address><City>new york</City><Cuisine>seafood</Cuisine><Cluster>229</Cluster></Restaurant>
<Restaurant><Name>duane park cafe</Name><Address>157 duane st.  between w. broadway and hudson st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>230</Cluster></Restaurant>
<Restaurant><Name>el teddy's</Name><Address>219 w. broadway  between franklin and white sts.</Address><City>new york</City><Cuisine>mexican</Cuisine><Cluster>231</Cluster></Restaurant>
<Restaurant><Name>emily's</Name><Address>1325 5th ave. at 111th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>232</Cluster></Restaurant>
<Restaurant><Name>empire korea</Name><Address>6 e. 32nd st.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>233</Cluster></Restaurant>
<Restaurant><Name>ernie's</Name><Address>2150 broadway  between 75th and 76th sts.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>234</Cluster></Restaurant>
<Restaurant><Name>evergreen cafe</Name><Address>1288 1st ave. at 69th st.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>235</Cluster></Restaurant>
<Restaurant><Name>f. ille ponte ristorante</Name><Address>39 desbrosses st.  near west st.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>236</Cluster></Restaurant>
<Restaurant><Name>felix</Name><Address>340 w. broadway at grand st.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>237</Cluster></Restaurant>
<Restaurant><Name>ferrier</Name><Address>29 e. 65th st.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>238</Cluster></Restaurant>
<Restaurant><Name>fifty seven fifty seven</Name><Address>57 e. 57th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>239</Cluster></Restaurant>
<Restaurant><Name>film center cafe</Name><Address>635 9th ave.  between 44th and 45th sts.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>240</Cluster></Restaurant>
<Restaurant><Name>fiorello's roman cafe</Name><Address>1900 broadway  between 63rd and 64th sts.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>241</Cluster></Restaurant>
<Restaurant><Name>firehouse</Name><Address>522 columbus ave.  between 85th and 86th sts.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>242</Cluster></Restaurant>
<Restaurant><Name>first</Name><Address>87 1st ave.  between 5th and 6th sts.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>243</Cluster></Restaurant>
<Restaurant><Name>fishin eddie</Name><Address>73 w. 71st st.</Address><City>new york</City><Cuisine>seafood</Cuisine><Cluster>244</Cluster></Restaurant>
<Restaurant><Name>fleur de jour</Name><Address>348 e. 62nd st.</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>245</Cluster></Restaurant>
<Restaurant><Name>flowers</Name><Address>21 west 17th st.  between 5th and 6th aves.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>246</Cluster></Restaurant>
<Restaurant><Name>follonico</Name><Address>6 w. 24th st.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>247</Cluster></Restaurant>
<Restaurant><Name>fraunces tavern</Name><Address>54 pearl st. at broad st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>248</Cluster></Restaurant>
<Restaurant><Name>french roast</Name><Address>458 6th ave. at 11th st.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>249</Cluster></Restaurant>
<Restaurant><Name>french roast cafe</Name><Address>2340 broadway at 85th st.</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>250</Cluster></Restaurant>
<Restaurant><Name>frico bar</Name><Address>402 w. 43rd st.  off 9th ave.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>251</Cluster></Restaurant>
<Restaurant><Name>fujiyama mama</Name><Address>467 columbus ave.  between 82nd and 83rd sts.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>252</Cluster></Restaurant>
<Restaurant><Name>gabriela's</Name><Address>685 amsterdam ave. at 93rd st.</Address><City>new york</City><Cuisine>mexican</Cuisine><Cluster>253</Cluster></Restaurant>
<Restaurant><Name>gallagher's</Name><Address>228 w. 52nd st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>254</Cluster></Restaurant>
<Restaurant><Name>gianni's</Name><Address>15 fulton st.</Address><City>new york</City><Cuisine>seafood</Cuisine><Cluster>255</Cluster></Restaurant>
<Restaurant><Name>girafe</Name><Address>208 e. 58th st.  between 2nd and 3rd aves.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>256</Cluster></Restaurant>
<Restaurant><Name>global</Name><Address>33 93 2nd ave.  between 5th and 6th sts.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>257</Cluster></Restaurant>
<Restaurant><Name>golden unicorn</Name><Address>18 e. broadway at catherine st.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>258</Cluster></Restaurant>
<Restaurant><Name>grand ticino</Name><Address>228 thompson st.  between w. 3rd and bleecker sts.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>259</Cluster></Restaurant>
<Restaurant><Name>halcyon</Name><Address>151 w. 54th st.  in the rihga royal hotel</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>260</Cluster></Restaurant>
<Restaurant><Name>hard rock cafe</Name><Address>221 w. 57th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>261</Cluster></Restaurant>
<Restaurant><Name>hi-life restaurant and lounge</Name><Address>1340 1st ave. at 72nd st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>262</Cluster></Restaurant>
<Restaurant><Name>home</Name><Address>20 cornelia st.  between bleecker and w. 4th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>263</Cluster></Restaurant>
<Restaurant><Name>hudson river club</Name><Address>4 world financial center</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>264</Cluster></Restaurant>
<Restaurant><Name>i trulli</Name><Address>122 e. 27th st.  between lexington and park aves.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>265</Cluster></Restaurant>
<Restaurant><Name>il cortile</Name><Address>125 mulberry st.  between canal and hester sts.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>266</Cluster></Restaurant>
<Restaurant><Name>il nido</Name><Address>251 e. 53rd st.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>267</Cluster></Restaurant>
<Restaurant><Name>inca grill</Name><Address>492 broome st.  near w. broadway</Address><City>new york</City><Cuisine>latin american</Cuisine><Cluster>268</Cluster></Restaurant>
<Restaurant><Name>indochine</Name><Address>430 lafayette st.  between 4th st. and astor pl.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>269</Cluster></Restaurant>
<Restaurant><Name>internet cafe</Name><Address>82 e. 3rd st.  between 1st and 2nd aves.</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>270</Cluster></Restaurant>
<Restaurant><Name>ipanema</Name><Address>13 w. 46th st.</Address><City>new york</City><Cuisine>latin american</Cuisine><Cluster>271</Cluster></Restaurant>
<Restaurant><Name>jean lafitte</Name><Address>68 w. 58th st.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>272</Cluster></Restaurant>
<Restaurant><Name>jewel of india</Name><Address>15 w. 44th st.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>273</Cluster></Restaurant>
<Restaurant><Name>jimmy sung's</Name><Address>219 e. 44th st.  between 2nd and 3rd aves.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>274</Cluster></Restaurant>
<Restaurant><Name>joe allen</Name><Address>326 w. 46th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>275</Cluster></Restaurant>
<Restaurant><Name>judson grill</Name><Address>152 w. 52nd st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>276</Cluster></Restaurant>
<Restaurant><Name>l'absinthe</Name><Address>227 e. 67th st.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>277</Cluster></Restaurant>
<Restaurant><Name>l'auberge</Name><Address>1191 1st ave.  between 64th and 65th sts.</Address><City>new york</City><Cuisine>middle eastern</Cuisine><Cluster>278</Cluster></Restaurant>
<Restaurant><Name>l'auberge du midi</Name><Address>310 w. 4th st.  between w. 12th and bank sts.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>279</Cluster></Restaurant>
<Restaurant><Name>l'udo</Name><Address>432 lafayette st.  near astor pl.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>280</Cluster></Restaurant>
<Restaurant><Name>la reserve</Name><Address>4 w. 49th st.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>281</Cluster></Restaurant>
<Restaurant><Name>lanza restaurant</Name><Address>168 1st ave.  between 10th and 11th sts.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>282</Cluster></Restaurant>
<Restaurant><Name>lattanzi ristorante</Name><Address>361 w. 46th st.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>283</Cluster></Restaurant>
<Restaurant><Name>layla</Name><Address>211 w. broadway at franklin st.</Address><City>new york</City><Cuisine>middle eastern</Cuisine><Cluster>284</Cluster></Restaurant>
<Restaurant><Name>le chantilly</Name><Address>106 e. 57th st.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>285</Cluster></Restaurant>
<Restaurant><Name>le colonial</Name><Address>149 e. 57th st.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>286</Cluster></Restaurant>
<Restaurant><Name>le gamin</Name><Address>50 macdougal st.  between houston and prince sts.</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>287</Cluster></Restaurant>
<Restaurant><Name>le jardin</Name><Address>25 cleveland pl.  near spring st.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>288</Cluster></Restaurant>
<Restaurant><Name>le madri</Name><Address>168 w. 18th st.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>289</Cluster></Restaurant>
<Restaurant><Name>le marais</Name><Address>150 w. 46th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>290</Cluster></Restaurant>
<Restaurant><Name>le perigord</Name><Address>405 e. 52nd st.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>291</Cluster></Restaurant>
<Restaurant><Name>le select</Name><Address>507 columbus ave.  between 84th and 85th sts.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>292</Cluster></Restaurant>
<Restaurant><Name>les halles</Name><Address>411 park ave. s  between 28th and 29th sts.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>293</Cluster></Restaurant>
<Restaurant><Name>lincoln tavern</Name><Address>51 w. 64th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>294</Cluster></Restaurant>
<Restaurant><Name>lola</Name><Address>30 west 22nd st.  between 5th and 6th ave.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>295</Cluster></Restaurant>
<Restaurant><Name>lucky strike</Name><Address>59 grand st.  between wooster st. and w. broadway</Address><City>new york</City><Cuisine>or 212/941-0772 american</Cuisine><Cluster>296</Cluster></Restaurant>
<Restaurant><Name>mad fish</Name><Address>2182 broadway  between 77th and 78th sts.</Address><City>new york</City><Cuisine>seafood</Cuisine><Cluster>297</Cluster></Restaurant>
<Restaurant><Name>main street</Name><Address>446 columbus ave.  between 81st and 82nd sts.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>298</Cluster></Restaurant>
<Restaurant><Name>mangia e bevi</Name><Address>800 9th ave. at 53rd st.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>299</Cluster></Restaurant>
<Restaurant><Name>manhattan cafe</Name><Address>1161 1st ave.  between 63rd and 64th sts.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>300</Cluster></Restaurant>
<Restaurant><Name>manila garden</Name><Address>325 e. 14th st.  between 1st and 2nd aves.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>301</Cluster></Restaurant>
<Restaurant><Name>marichu</Name><Address>342 e. 46th st.  between 1st and 2nd aves.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>302</Cluster></Restaurant>
<Restaurant><Name>match</Name><Address>160 mercer st.  between houston and prince sts.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>304</Cluster></Restaurant>
<Restaurant><Name>matthew's</Name><Address>1030 3rd ave. at 61st st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>305</Cluster></Restaurant>
<Restaurant><Name>mavalli palace</Name><Address>46 e. 29th st.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>306</Cluster></Restaurant>
<Restaurant><Name>milan cafe and coffee bar</Name><Address>120 w. 23rd st.</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>307</Cluster></Restaurant>
<Restaurant><Name>monkey bar</Name><Address>60 e. 54th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>308</Cluster></Restaurant>
<Restaurant><Name>montien</Name><Address>1134 1st ave.   between 62nd and 63rd sts.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>309</Cluster></Restaurant>
<Restaurant><Name>morton's</Name><Address>551 5th ave. at 45th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>310</Cluster></Restaurant>
<Restaurant><Name>motown cafe</Name><Address>104 w. 57th st.  near 6th ave.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>311</Cluster></Restaurant>
<Restaurant><Name>new york kom tang soot bul house</Name><Address>32 w. 32nd st.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>312</Cluster></Restaurant>
<Restaurant><Name>new york noodletown</Name><Address>28 1/2 bowery at bayard st.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>313</Cluster></Restaurant>
<Restaurant><Name>newsbar</Name><Address>2 w. 19th st.</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>314</Cluster></Restaurant>
<Restaurant><Name>odeon</Name><Address>145 w. broadway at thomas st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>315</Cluster></Restaurant>
<Restaurant><Name>orso</Name><Address>322 w. 46th st.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>316</Cluster></Restaurant>
<Restaurant><Name>osteria al droge</Name><Address>142 w. 44th st.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>317</Cluster></Restaurant>
<Restaurant><Name>otabe</Name><Address>68 e. 56th st.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>318</Cluster></Restaurant>
<Restaurant><Name>pacifica</Name><Address>138 lafayette st.  between canal and howard sts.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>319</Cluster></Restaurant>
<Restaurant><Name>palio</Name><Address>151 w. 51st. st.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>320</Cluster></Restaurant>
<Restaurant><Name>pamir</Name><Address>1065 1st ave.  at 58th st.</Address><City>new york</City><Cuisine>middle eastern</Cuisine><Cluster>321</Cluster></Restaurant>
<Restaurant><Name>parioli romanissimo</Name><Address>24 e. 81st st.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>322</Cluster></Restaurant>
<Restaurant><Name>patria</Name><Address>250 park ave. s at 20th st.</Address><City>new york</City><Cuisine>latin american</Cuisine><Cluster>323</Cluster></Restaurant>
<Restaurant><Name>peacock alley</Name><Address>301 park ave.  between 49th and 50th sts.</Address><City>new york</City><Cuisine>french</Cuisine><Cluster>324</Cluster></Restaurant>
<Restaurant><Name><![CDATA[pen & pencil]]></Name><Address>205 e. 45th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>325</Cluster></Restaurant>
<Restaurant><Name>penang soho</Name><Address>109 spring st.  between greene and mercer sts.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>326</Cluster></Restaurant>
<Restaurant><Name>persepolis</Name><Address>1423 2nd ave.  between 74th and 75th sts.</Address><City>new york</City><Cuisine>middle eastern</Cuisine><Cluster>327</Cluster></Restaurant>
<Restaurant><Name>planet hollywood</Name><Address>140 w. 57th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>328</Cluster></Restaurant>
<Restaurant><Name>pomaire</Name><Address>371 w. 46th st.  off 9th ave.</Address><City>new york</City><Cuisine>latin american</Cuisine><Cluster>329</Cluster></Restaurant>
<Restaurant><Name>popover cafe</Name><Address>551 amsterdam ave.  between 86th and 87th sts.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>330</Cluster></Restaurant>
<Restaurant><Name>post house</Name><Address>28 e. 63rd st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>331</Cluster></Restaurant>
<Restaurant><Name>rain</Name><Address>100 w. 82nd st.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>332</Cluster></Restaurant>
<Restaurant><Name>red tulip</Name><Address>439 e. 75th st.</Address><City>new york</City><Cuisine>eastern european</Cuisine><Cluster>333</Cluster></Restaurant>
<Restaurant><Name>remi</Name><Address>145 w. 53rd st.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>334</Cluster></Restaurant>
<Restaurant><Name>republic</Name><Address>37a union sq. w  between 16th and 17th sts.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>335</Cluster></Restaurant>
<Restaurant><Name>roettelle a. g</Name><Address>126 e. 7th st.  between 1st ave. and ave. a</Address><City>new york</City><Cuisine>continental</Cuisine><Cluster>336</Cluster></Restaurant>
<Restaurant><Name>rosa mexicano</Name><Address>1063 1st ave. at 58th st.</Address><City>new york</City><Cuisine>mexican</Cuisine><Cluster>337</Cluster></Restaurant>
<Restaurant><Name>ruth's chris</Name><Address>148 w. 51st st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>338</Cluster></Restaurant>
<Restaurant><Name>s.p.q.r</Name><Address>133 mulberry st.  between hester and grand sts.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>339</Cluster></Restaurant>
<Restaurant><Name>sal anthony's</Name><Address>55 irving pl.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>340</Cluster></Restaurant>
<Restaurant><Name>sammy's roumanian steak house</Name><Address>157 chrystie st. at delancey st.</Address><City>new york</City><Cuisine>east european</Cuisine><Cluster>341</Cluster></Restaurant>
<Restaurant><Name>san pietro</Name><Address>18 e. 54th st.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>342</Cluster></Restaurant>
<Restaurant><Name>sant ambroeus</Name><Address>1000 madison ave.  between 77th and 78th sts.</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>343</Cluster></Restaurant>
<Restaurant><Name>sarabeth's kitchen</Name><Address>423 amsterdam ave.  between 80th and 81st sts.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>344</Cluster></Restaurant>
<Restaurant><Name>sea grill</Name><Address>19 w. 49th st.</Address><City>new york</City><Cuisine>seafood</Cuisine><Cluster>345</Cluster></Restaurant>
<Restaurant><Name>serendipity</Name><Address>3 225 e. 60th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>346</Cluster></Restaurant>
<Restaurant><Name>seventh regiment mess and bar</Name><Address>643 park ave. at 66th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>347</Cluster></Restaurant>
<Restaurant><Name>sfuzzi</Name><Address>58 w. 65th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>348</Cluster></Restaurant>
<Restaurant><Name>shaan</Name><Address>57 w. 48th st.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>349</Cluster></Restaurant>
<Restaurant><Name>sofia fabulous pizza</Name><Address>1022 madison ave.  near 79th st.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>350</Cluster></Restaurant>
<Restaurant><Name><![CDATA[spring street natural restaurant & bar]]></Name><Address>62 spring st. at lafayette st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>351</Cluster></Restaurant>
<Restaurant><Name>stage deli</Name><Address>834 7th ave.  between 53rd and 54th sts.</Address><City>new york</City><Cuisine>delicatessen</Cuisine><Cluster>352</Cluster></Restaurant>
<Restaurant><Name>stingray</Name><Address>428 amsterdam ave.  between 80th and 81st sts.</Address><City>new york</City><Cuisine>seafood</Cuisine><Cluster>353</Cluster></Restaurant>
<Restaurant><Name>sweet'n'tart cafe</Name><Address>76 mott st. at canal st.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>354</Cluster></Restaurant>
<Restaurant><Name>t salon</Name><Address>143 mercer st. at prince st.</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>355</Cluster></Restaurant>
<Restaurant><Name>tang pavillion</Name><Address>65 w. 55th st.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>356</Cluster></Restaurant>
<Restaurant><Name>tapika</Name><Address>950 8th ave. at 56th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>357</Cluster></Restaurant>
<Restaurant><Name>teresa's</Name><Address>103 1st ave.  between 6th and 7th sts.</Address><City>new york</City><Cuisine>east european</Cuisine><Cluster>358</Cluster></Restaurant>
<Restaurant><Name>the coffee pot</Name><Address>350 9th ave. at 49th st.</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>360</Cluster></Restaurant>
<Restaurant><Name>the savannah club</Name><Address>2420 broadway at 89th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>361</Cluster></Restaurant>
<Restaurant><Name>trattoria dell'arte</Name><Address>900 7th ave.  between 56th and 57th sts.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>362</Cluster></Restaurant>
<Restaurant><Name>triangolo</Name><Address>345 e. 83rd st.</Address><City>new york</City><Cuisine>italian</Cuisine><Cluster>363</Cluster></Restaurant>
<Restaurant><Name>tribeca grill</Name><Address>375 greenwich st.  near franklin st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>364</Cluster></Restaurant>
<Restaurant><Name>trois jean</Name><Address>154 e. 79th st.  between lexington and 3rd aves.</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>365</Cluster></Restaurant>
<Restaurant><Name>tse yang</Name><Address>34 e. 51st st.</Address><City>new york</City><Cuisine>asian</Cuisine><Cluster>366</Cluster></Restaurant>
<Restaurant><Name>turkish kitchen</Name><Address>386 3rd ave.  between 27th and 28th sts.</Address><City>new york</City><Cuisine>middle eastern</Cuisine><Cluster>367</Cluster></Restaurant>
<Restaurant><Name>two two two</Name><Address>222 w. 79th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>368</Cluster></Restaurant>
<Restaurant><Name>veniero's pasticceria</Name><Address>342 e. 11th st.  near 1st ave.</Address><City>new york</City><Cuisine>coffee bar</Cuisine><Cluster>369</Cluster></Restaurant>
<Restaurant><Name>verbena</Name><Address>54 irving pl. at 17th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>370</Cluster></Restaurant>
<Restaurant><Name>victor's cafe</Name><Address>52 236 w. 52nd st.</Address><City>new york</City><Cuisine>latin american</Cuisine><Cluster>371</Cluster></Restaurant>
<Restaurant><Name><![CDATA[vince & eddie's]]></Name><Address>70 w. 68th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>372</Cluster></Restaurant>
<Restaurant><Name>vong</Name><Address>200 e. 54th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>373</Cluster></Restaurant>
<Restaurant><Name>water club</Name><Address>500 e. 30th st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>374</Cluster></Restaurant>
<Restaurant><Name>west</Name><Address>63rd street steakhouse 44 w. 63rd st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>375</Cluster></Restaurant>
<Restaurant><Name>xunta</Name><Address>174 1st ave.  between 10th and 11th sts.</Address><City>new york</City><Cuisine>mediterranean</Cuisine><Cluster>376</Cluster></Restaurant>
<Restaurant><Name>zen palate</Name><Address>34 union sq. e at 16th st.</Address><City>new york</City><Cuisine>and 212/614-9345 asian</Cuisine><Cluster>377</Cluster></Restaurant>
<Restaurant><Name>zoe</Name><Address>90 prince st.  between broadway and mercer st.</Address><City>new york</City><Cuisine>american</Cuisine><Cluster>378</Cluster></Restaurant>
<Restaurant><Name>abbey</Name><Address>163 ponce de leon ave.</Address><City>atlanta</City><Cuisine>international</Cuisine><Cluster>379</Cluster></Restaurant>
<Restaurant><Name>aleck's barbecue heaven</Name><Address>783 martin luther king jr. dr.</Address><City>atlanta</City><Cuisine>barbecue</Cuisine><Cluster>380</Cluster></Restaurant>
<Restaurant><Name>annie's thai castle</Name><Address>3195 roswell rd.</Address><City>atlanta</City><Cuisine>asian</Cuisine><Cluster>381</Cluster></Restaurant>
<Restaurant><Name>anthonys</Name><Address>3109 piedmont rd.  just south of peachtree rd.</Address><City>atlanta</City><Cuisine>american</Cuisine><Cluster>382</Cluster></Restaurant>
<Restaurant><Name>atlanta fish market</Name><Address>265 pharr rd.</Address><City>atlanta</City><Cuisine>american</Cuisine><Cluster>383</Cluster></Restaurant>
<Restaurant><Name>beesley's of buckhead</Name><Address>260 e. paces ferry road</Address><City>atlanta</City><Cuisine>continental</Cuisine><Cluster>384</Cluster></Restaurant>
<Restaurant><Name>bertolini's</Name><Address>3500 peachtree rd.  phipps plaza</Address><City>atlanta</City><Cuisine>italian</Cuisine><Cluster>385</Cluster></Restaurant>
<Restaurant><Name>bistango</Name><Address>1100 peachtree st.</Address><City>atlanta</City><Cuisine>mediterranean</Cuisine><Cluster>386</Cluster></Restaurant>
<Restaurant><Name>cafe renaissance</Name><Address>7050 jimmy carter blvd.  norcross</Address><City>atlanta</City><Cuisine>american</Cuisine><Cluster>387</Cluster></Restaurant>
<Restaurant><Name>camille's</Name><Address>1186 n. highland ave.</Address><City>atlanta</City><Cuisine>italian</Cuisine><Cluster>388</Cluster></Restaurant>
<Restaurant><Name>cassis</Name><Address>3300 peachtree rd.  grand hyatt</Address><City>atlanta</City><Cuisine>mediterranean</Cuisine><Cluster>389</Cluster></Restaurant>
<Restaurant><Name>city grill</Name><Address>50 hurt plaza</Address><City>atlanta</City><Cuisine>international</Cuisine><Cluster>390</Cluster></Restaurant>
<Restaurant><Name>colonnade restaurant</Name><Address>1879 cheshire bridge rd.</Address><City>atlanta</City><Cuisine>southern</Cuisine><Cluster>392</Cluster></Restaurant>
<Restaurant><Name>dante's down the hatch  buckhead</Name><Address>3380 peachtree rd.</Address><City>atlanta</City><Cuisine>continental</Cuisine><Cluster>393</Cluster></Restaurant>
<Restaurant><Name>dante's down the hatch</Name><Address>underground underground mall  underground atlanta</Address><City>atlanta</City><Cuisine>continental</Cuisine><Cluster>394</Cluster></Restaurant>
<Restaurant><Name>fat matt's rib shack</Name><Address>1811 piedmont ave.  near cheshire bridge rd.</Address><City>atlanta</City><Cuisine>barbecue</Cuisine><Cluster>395</Cluster></Restaurant>
<Restaurant><Name>french quarter food shop</Name><Address>923 peachtree st.  at 8th st.</Address><City>atlanta</City><Cuisine>southern</Cuisine><Cluster>396</Cluster></Restaurant>
<Restaurant><Name>holt bros. bar-b-q</Name><Address>6359 jimmy carter blvd.  at buford hwy.  norcross</Address><City>atlanta</City><Cuisine>barbecue</Cuisine><Cluster>397</Cluster></Restaurant>
<Restaurant><Name>horseradish grill</Name><Address>4320 powers ferry rd.</Address><City>atlanta</City><Cuisine>southern</Cuisine><Cluster>398</Cluster></Restaurant>
<Restaurant><Name>hsu's gourmet</Name><Address>192 peachtree center ave.  at international blvd.</Address><City>atlanta</City><Cuisine>asian</Cuisine><Cluster>399</Cluster></Restaurant>
<Restaurant><Name>imperial fez</Name><Address>2285 peachtree rd.  peachtree battle condominium</Address><City>atlanta</City><Cuisine>mediterranean</Cuisine><Cluster>400</Cluster></Restaurant>
<Restaurant><Name>kamogawa</Name><Address>3300 peachtree rd.  grand hyatt</Address><City>atlanta</City><Cuisine>asian</Cuisine><Cluster>401</Cluster></Restaurant>
<Restaurant><Name>la grotta at ravinia dunwoody rd.</Name><Address>holiday inn/crowne plaza at ravinia  dunwoody</Address><City>atlanta</City><Cuisine>italian</Cuisine><Cluster>402</Cluster></Restaurant>
<Restaurant><Name>little szechuan</Name><Address>c buford hwy.  northwoods plaza  doraville</Address><City>atlanta</City><Cuisine>asian</Cuisine><Cluster>403</Cluster></Restaurant>
<Restaurant><Name>luna si</Name><Address>1931 peachtree rd.</Address><City>atlanta</City><Cuisine>continental</Cuisine><Cluster>405</Cluster></Restaurant>
<Restaurant><Name>mambo restaurante cubano</Name><Address>1402 n. highland ave.</Address><City>atlanta</City><Cuisine>caribbean</Cuisine><Cluster>406</Cluster></Restaurant>
<Restaurant><Name>mckinnon's louisiane</Name><Address>3209 maple dr.</Address><City>atlanta</City><Cuisine>southern</Cuisine><Cluster>407</Cluster></Restaurant>
<Restaurant><Name>mi spia dunwoody rd.</Name><Address>park place  across from perimeter mall  dunwoody</Address><City>atlanta</City><Cuisine>italian</Cuisine><Cluster>408</Cluster></Restaurant>
<Restaurant><Name>nickiemoto's: a sushi bar</Name><Address>247 buckhead ave.  east village sq.</Address><City>atlanta</City><Cuisine>fusion</Cuisine><Cluster>409</Cluster></Restaurant>
<Restaurant><Name>palisades</Name><Address>1829 peachtree rd.</Address><City>atlanta</City><Cuisine>continental</Cuisine><Cluster>410</Cluster></Restaurant>
<Restaurant><Name>pleasant peasant</Name><Address>555 peachtree st.  at linden ave.</Address><City>atlanta</City><Cuisine>american</Cuisine><Cluster>411</Cluster></Restaurant>
<Restaurant><Name>pricci</Name><Address>500 pharr rd.</Address><City>atlanta</City><Cuisine>italian</Cuisine><Cluster>412</Cluster></Restaurant>
<Restaurant><Name><![CDATA[r.j.'s uptown kitchen & wine bar]]></Name><Address>870 n. highland ave.</Address><City>atlanta</City><Cuisine>american</Cuisine><Cluster>413</Cluster></Restaurant>
<Restaurant><Name>rib ranch</Name><Address>25 irby ave.</Address><City>atlanta</City><Cuisine>barbecue</Cuisine><Cluster>414</Cluster></Restaurant>
<Restaurant><Name>sa tsu ki</Name><Address>3043 buford hwy.</Address><City>atlanta</City><Cuisine>asian</Cuisine><Cluster>415</Cluster></Restaurant>
<Restaurant><Name>sato sushi and thai</Name><Address>6050 peachtree pkwy.  norcross</Address><City>atlanta</City><Cuisine>asian</Cuisine><Cluster>416</Cluster></Restaurant>
<Restaurant><Name>south city kitchen</Name><Address>1144 crescent ave.</Address><City>atlanta</City><Cuisine>southern</Cuisine><Cluster>417</Cluster></Restaurant>
<Restaurant><Name>south of france</Name><Address>2345 cheshire bridge rd.</Address><City>atlanta</City><Cuisine>french</Cuisine><Cluster>418</Cluster></Restaurant>
<Restaurant><Name>stringer's fish camp and oyster bar</Name><Address>3384 shallowford rd.  chamblee</Address><City>atlanta</City><Cuisine>southern</Cuisine><Cluster>419</Cluster></Restaurant>
<Restaurant><Name>sundown cafe</Name><Address>2165 cheshire bridge rd.</Address><City>atlanta</City><Cuisine>american</Cuisine><Cluster>420</Cluster></Restaurant>
<Restaurant><Name>taste of new orleans</Name><Address>889 w. peachtree st.</Address><City>atlanta</City><Cuisine>southern</Cuisine><Cluster>421</Cluster></Restaurant>
<Restaurant><Name>tomtom</Name><Address>3393 peachtree rd.</Address><City>atlanta</City><Cuisine>continental</Cuisine><Cluster>422</Cluster></Restaurant>
<Restaurant><Name>antonio's</Name><Address>3700 w. flamingo</Address><City>las vegas</City><Cuisine>italian</Cuisine><Cluster>423</Cluster></Restaurant>
<Restaurant><Name>bally's big kitchen</Name><Address>3645 las vegas blvd. s</Address><City>las vegas</City><Cuisine>buffets</Cuisine><Cluster>424</Cluster></Restaurant>
<Restaurant><Name>bamboo garden</Name><Address>4850 flamingo rd.</Address><City>las vegas</City><Cuisine>asian</Cuisine><Cluster>425</Cluster></Restaurant>
<Restaurant><Name>battista's hole in the wall</Name><Address>4041 audrie st. at flamingo rd.</Address><City>las vegas</City><Cuisine>italian</Cuisine><Cluster>426</Cluster></Restaurant>
<Restaurant><Name>bertolini's</Name><Address>3570 las vegas blvd. s</Address><City>las vegas</City><Cuisine>italian</Cuisine><Cluster>427</Cluster></Restaurant>
<Restaurant><Name>binion's coffee shop</Name><Address>128 fremont st.</Address><City>las vegas</City><Cuisine>coffee shops/diners</Cuisine><Cluster>428</Cluster></Restaurant>
<Restaurant><Name>bistro</Name><Address>3400 las vegas blvd. s</Address><City>las vegas</City><Cuisine>continental</Cuisine><Cluster>429</Cluster></Restaurant>
<Restaurant><Name>broiler</Name><Address>4111 boulder hwy.</Address><City>las vegas</City><Cuisine>american</Cuisine><Cluster>430</Cluster></Restaurant>
<Restaurant><Name>bugsy's diner</Name><Address>3555 las vegas blvd. s</Address><City>las vegas</City><Cuisine>coffee shops/diners</Cuisine><Cluster>431</Cluster></Restaurant>
<Restaurant><Name>cafe michelle</Name><Address>1350 e. flamingo rd.</Address><City>las vegas</City><Cuisine>american</Cuisine><Cluster>432</Cluster></Restaurant>
<Restaurant><Name>cafe roma</Name><Address>3570 las vegas blvd. s</Address><City>las vegas</City><Cuisine>coffee shops/diners</Cuisine><Cluster>433</Cluster></Restaurant>
<Restaurant><Name>capozzoli's</Name><Address>3333 s. maryland pkwy.</Address><City>las vegas</City><Cuisine>italian</Cuisine><Cluster>434</Cluster></Restaurant>
<Restaurant><Name>carnival world</Name><Address>3700 w. flamingo rd.</Address><City>las vegas</City><Cuisine>buffets</Cuisine><Cluster>435</Cluster></Restaurant>
<Restaurant><Name>center stage plaza hotel</Name><Address>1 main st.</Address><City>las vegas</City><Cuisine>american</Cuisine><Cluster>436</Cluster></Restaurant>
<Restaurant><Name>circus circus</Name><Address>2880 las vegas blvd. s</Address><City>las vegas</City><Cuisine>buffets</Cuisine><Cluster>437</Cluster></Restaurant>
<Restaurant><Name>empress court</Name><Address>3570 las vegas blvd. s</Address><City>las vegas</City><Cuisine>asian</Cuisine><Cluster>438</Cluster></Restaurant>
<Restaurant><Name>feast</Name><Address>2411 w. sahara ave.</Address><City>las vegas</City><Cuisine>buffets</Cuisine><Cluster>439</Cluster></Restaurant>
<Restaurant><Name>golden nugget hotel</Name><Address>129 e. fremont st.</Address><City>las vegas</City><Cuisine>buffets</Cuisine><Cluster>440</Cluster></Restaurant>
<Restaurant><Name>golden steer</Name><Address>308 w. sahara ave.</Address><City>las vegas</City><Cuisine>steak houses</Cuisine><Cluster>441</Cluster></Restaurant>
<Restaurant><Name>lillie langtry's</Name><Address>129 e. fremont st.</Address><City>las vegas</City><Cuisine>asian</Cuisine><Cluster>442</Cluster></Restaurant>
<Restaurant><Name>mandarin court</Name><Address>1510 e. flamingo rd.</Address><City>las vegas</City><Cuisine>asian</Cuisine><Cluster>443</Cluster></Restaurant>
<Restaurant><Name>margarita's mexican cantina</Name><Address>3120 las vegas blvd. s</Address><City>las vegas</City><Cuisine>mexican</Cuisine><Cluster>444</Cluster></Restaurant>
<Restaurant><Name>mary's diner</Name><Address>5111 w. boulder hwy.</Address><City>las vegas</City><Cuisine>coffee shops/diners</Cuisine><Cluster>445</Cluster></Restaurant>
<Restaurant><Name>mikado</Name><Address>3400 las vegas blvd. s</Address><City>las vegas</City><Cuisine>asian</Cuisine><Cluster>446</Cluster></Restaurant>
<Restaurant><Name>pamplemousse</Name><Address>400 e. sahara ave.</Address><City>las vegas</City><Cuisine>continental</Cuisine><Cluster>447</Cluster></Restaurant>
<Restaurant><Name>ralph's diner</Name><Address>3000 las vegas blvd. s</Address><City>las vegas</City><Cuisine>coffee shops/diners</Cuisine><Cluster>448</Cluster></Restaurant>
<Restaurant><Name>the bacchanal</Name><Address>3570 las vegas blvd. s</Address><City>las vegas</City><Cuisine>only in las vegas</Cuisine><Cluster>449</Cluster></Restaurant>
<Restaurant><Name>venetian</Name><Address>3713 w. sahara ave.</Address><City>las vegas</City><Cuisine>italian</Cuisine><Cluster>450</Cluster></Restaurant>
<Restaurant><Name>viva mercado's</Name><Address>6182 w. flamingo rd.</Address><City>las vegas</City><Cuisine>mexican</Cuisine><Cluster>451</Cluster></Restaurant>
<Restaurant><Name>yolie's</Name><Address>3900 paradise rd.</Address><City>las vegas</City><Cuisine>steak houses</Cuisine><Cluster>452</Cluster></Restaurant>
<Restaurant><Name>2223</Name><Address>2223 market st.</Address><City>san francisco</City><Cuisine>american</Cuisine><Cluster>453</Cluster></Restaurant>
<Restaurant><Name>acquarello</Name><Address>1722 sacramento st.</Address><City>san francisco</City><Cuisine>italian</Cuisine><Cluster>454</Cluster></Restaurant>
<Restaurant><Name>bardelli's</Name><Address>243 o'farrell st.</Address><City>san francisco</City><Cuisine>old san francisco</Cuisine><Cluster>455</Cluster></Restaurant>
<Restaurant><Name>betelnut</Name><Address>2030 union st.</Address><City>san francisco</City><Cuisine>asian</Cuisine><Cluster>456</Cluster></Restaurant>
<Restaurant><Name>bistro roti</Name><Address>155 steuart st.</Address><City>san francisco</City><Cuisine>french</Cuisine><Cluster>457</Cluster></Restaurant>
<Restaurant><Name>bix</Name><Address>56 gold st.</Address><City>san francisco</City><Cuisine>american</Cuisine><Cluster>458</Cluster></Restaurant>
<Restaurant><Name>bizou</Name><Address>598 fourth st.</Address><City>san francisco</City><Cuisine>french</Cuisine><Cluster>459</Cluster></Restaurant>
<Restaurant><Name>buca giovanni</Name><Address>800 greenwich st.</Address><City>san francisco</City><Cuisine>italian</Cuisine><Cluster>460</Cluster></Restaurant>
<Restaurant><Name>cafe adriano</Name><Address>3347 fillmore st.</Address><City>san francisco</City><Cuisine>italian</Cuisine><Cluster>461</Cluster></Restaurant>
<Restaurant><Name>cafe marimba</Name><Address>2317 chestnut st.</Address><City>san francisco</City><Cuisine>mexican/latin american/spanish</Cuisine><Cluster>462</Cluster></Restaurant>
<Restaurant><Name>california culinary academy</Name><Address>625 polk st.</Address><City>san francisco</City><Cuisine>french</Cuisine><Cluster>463</Cluster></Restaurant>
<Restaurant><Name>capp's corner</Name><Address>1600 powell st.</Address><City>san francisco</City><Cuisine>italian</Cuisine><Cluster>464</Cluster></Restaurant>
<Restaurant><Name>carta</Name><Address>1772 market st.</Address><City>san francisco</City><Cuisine>american</Cuisine><Cluster>465</Cluster></Restaurant>
<Restaurant><Name>chevys</Name><Address>4th and howard sts.</Address><City>san francisco</City><Cuisine>mexican/latin american/spanish</Cuisine><Cluster>466</Cluster></Restaurant>
<Restaurant><Name>cypress club</Name><Address>500 jackson st.</Address><City>san francisco</City><Cuisine>american</Cuisine><Cluster>467</Cluster></Restaurant>
<Restaurant><Name>des alpes</Name><Address>732 broadway</Address><City>san francisco</City><Cuisine>french</Cuisine><Cluster>468</Cluster></Restaurant>
<Restaurant><Name>faz</Name><Address>161 sutter st.</Address><City>san francisco</City><Cuisine>greek and middle eastern</Cuisine><Cluster>469</Cluster></Restaurant>
<Restaurant><Name>fog city diner</Name><Address>1300 battery st.</Address><City>san francisco</City><Cuisine>american</Cuisine><Cluster>470</Cluster></Restaurant>
<Restaurant><Name>garden court</Name><Address>market and new montgomery sts.</Address><City>san francisco</City><Cuisine>old san francisco</Cuisine><Cluster>471</Cluster></Restaurant>
<Restaurant><Name>gaylord's</Name><Address>ghirardelli sq.</Address><City>san francisco</City><Cuisine>asian</Cuisine><Cluster>472</Cluster></Restaurant>
<Restaurant><Name>grand cafe hotel monaco</Name><Address>501 geary st.</Address><City>san francisco</City><Cuisine>american</Cuisine><Cluster>473</Cluster></Restaurant>
<Restaurant><Name>greens</Name><Address>bldg. a fort mason</Address><City>san francisco</City><Cuisine>vegetarian</Cuisine><Cluster>474</Cluster></Restaurant>
<Restaurant><Name>harbor village</Name><Address>4 embarcadero center</Address><City>san francisco</City><Cuisine>asian</Cuisine><Cluster>475</Cluster></Restaurant>
<Restaurant><Name>harris'</Name><Address>2100 van ness ave.</Address><City>san francisco</City><Cuisine>steak houses</Cuisine><Cluster>476</Cluster></Restaurant>
<Restaurant><Name>harry denton's</Name><Address>161 steuart st.</Address><City>san francisco</City><Cuisine>american</Cuisine><Cluster>477</Cluster></Restaurant>
<Restaurant><Name>hayes street grill</Name><Address>320 hayes st.</Address><City>san francisco</City><Cuisine>seafood</Cuisine><Cluster>478</Cluster></Restaurant>
<Restaurant><Name>helmand</Name><Address>430 broadway</Address><City>san francisco</City><Cuisine>greek and middle eastern</Cuisine><Cluster>479</Cluster></Restaurant>
<Restaurant><Name>hong kong flower lounge</Name><Address>5322 geary blvd.</Address><City>san francisco</City><Cuisine>asian</Cuisine><Cluster>480</Cluster></Restaurant>
<Restaurant><Name>hong kong villa</Name><Address>2332 clement st.</Address><City>san francisco</City><Cuisine>asian</Cuisine><Cluster>481</Cluster></Restaurant>
<Restaurant><Name>hyde street bistro</Name><Address>1521 hyde st.</Address><City>san francisco</City><Cuisine>italian</Cuisine><Cluster>482</Cluster></Restaurant>
<Restaurant><Name>il fornaio levi's plaza</Name><Address>1265 battery st.</Address><City>san francisco</City><Cuisine>italian</Cuisine><Cluster>483</Cluster></Restaurant>
<Restaurant><Name><![CDATA[izzy's steak & chop house]]></Name><Address>3345 steiner st.</Address><City>san francisco</City><Cuisine>steak houses</Cuisine><Cluster>484</Cluster></Restaurant>
<Restaurant><Name>jack's</Name><Address>615 sacramento st.</Address><City>san francisco</City><Cuisine>old san francisco</Cuisine><Cluster>485</Cluster></Restaurant>
<Restaurant><Name>kabuto sushi</Name><Address>5116 geary blvd.</Address><City>san francisco</City><Cuisine>asian</Cuisine><Cluster>486</Cluster></Restaurant>
<Restaurant><Name>katia's</Name><Address>600 5th ave.</Address><City>san francisco</City><Cluster>487</Cluster></Restaurant>
<Restaurant><Name>kuleto's</Name><Address>221 powell st.</Address><City>san francisco</City><Cuisine>italian</Cuisine><Cluster>488</Cluster></Restaurant>
<Restaurant><Name>kyo-ya. sheraton palace hotel</Name><Address>2 new montgomery st.  at market st.</Address><City>san francisco</City><Cuisine>asian</Cuisine><Cluster>489</Cluster></Restaurant>
<Restaurant><Name>l'osteria del forno</Name><Address>519 columbus ave.</Address><City>san francisco</City><Cuisine>italian</Cuisine><Cluster>490</Cluster></Restaurant>
<Restaurant><Name>le central</Name><Address>453 bush st.</Address><City>san francisco</City><Cuisine>french</Cuisine><Cluster>491</Cluster></Restaurant>
<Restaurant><Name>le soleil</Name><Address>133 clement st.</Address><City>san francisco</City><Cuisine>asian</Cuisine><Cluster>492</Cluster></Restaurant>
<Restaurant><Name>macarthur park</Name><Address>607 front st.</Address><City>san francisco</City><Cuisine>american</Cuisine><Cluster>493</Cluster></Restaurant>
<Restaurant><Name>manora</Name><Address>3226 mission st.</Address><City>san francisco</City><Cuisine>asian</Cuisine><Cluster>494</Cluster></Restaurant>
<Restaurant><Name>maykadeh</Name><Address>470 green st.</Address><City>san francisco</City><Cuisine>greek and middle eastern</Cuisine><Cluster>495</Cluster></Restaurant>
<Restaurant><Name><![CDATA[mccormick & kuleto's]]></Name><Address>ghirardelli sq.</Address><City>san francisco</City><Cuisine>seafood</Cuisine><Cluster>496</Cluster></Restaurant>
<Restaurant><Name>millennium</Name><Address>246 mcallister st.</Address><City>san francisco</City><Cuisine>vegetarian</Cuisine><Cluster>497</Cluster></Restaurant>
<Restaurant><Name>moose's</Name><Address>1652 stockton st.</Address><City>san francisco</City><Cuisine>mediterranean</Cuisine><Cluster>498</Cluster></Restaurant>
<Restaurant><Name>north india</Name><Address>3131 webster st.</Address><City>san francisco</City><Cuisine>asian</Cuisine><Cluster>499</Cluster></Restaurant>
<Restaurant><Name>one market</Name><Address>1 market st.</Address><City>san francisco</City><Cuisine>american</Cuisine><Cluster>500</Cluster></Restaurant>
<Restaurant><Name>oritalia</Name><Address>1915 fillmore st.</Address><City>san francisco</City><Cuisine>italian</Cuisine><Cluster>501</Cluster></Restaurant>
<Restaurant><Name>pacific pan pacific hotel</Name><Address>500 post st.</Address><City>san francisco</City><Cuisine>french</Cuisine><Cluster>502</Cluster></Restaurant>
<Restaurant><Name>palio d'asti</Name><Address>640 sacramento st.</Address><City>san francisco</City><Cuisine>italian</Cuisine><Cluster>503</Cluster></Restaurant>
<Restaurant><Name>pane e vino</Name><Address>3011 steiner st.</Address><City>san francisco</City><Cuisine>italian</Cuisine><Cluster>504</Cluster></Restaurant>
<Restaurant><Name>pastis</Name><Address>1015 battery st.</Address><City>san francisco</City><Cuisine>french</Cuisine><Cluster>505</Cluster></Restaurant>
<Restaurant><Name>perry's</Name><Address>1944 union st.</Address><City>san francisco</City><Cuisine>american</Cuisine><Cluster>506</Cluster></Restaurant>
<Restaurant><Name><![CDATA[r&g lounge]]></Name><Address>631 b kearny st.</Address><City>san francisco</City><Cuisine>or 415/982-3811 asian</Cuisine><Cluster>507</Cluster></Restaurant>
<Restaurant><Name>rubicon</Name><Address>558 sacramento st.</Address><City>san francisco</City><Cuisine>american</Cuisine><Cluster>508</Cluster></Restaurant>
<Restaurant><Name>rumpus</Name><Address>1 tillman pl.</Address><City>san francisco</City><Cuisine>american</Cuisine><Cluster>509</Cluster></Restaurant>
<Restaurant><Name>sanppo</Name><Address>1702 post st.</Address><City>san francisco</City><Cuisine>asian</Cuisine><Cluster>510</Cluster></Restaurant>
<Restaurant><Name>scala's bistro</Name><Address>432 powell st.</Address><City>san francisco</City><Cuisine>italian</Cuisine><Cluster>511</Cluster></Restaurant>
<Restaurant><Name>south park cafe</Name><Address>108 south park</Address><City>san francisco</City><Cuisine>french</Cuisine><Cluster>512</Cluster></Restaurant>
<Restaurant><Name>splendido embarcadero</Name><Address>4</Address><City>san francisco</City><Cuisine>mediterranean</Cuisine><Cluster>513</Cluster></Restaurant>
<Restaurant><Name>stars</Name><Address>150 redwood alley</Address><City>san francisco</City><Cuisine>american</Cuisine><Cluster>514</Cluster></Restaurant>
<Restaurant><Name>stars cafe</Name><Address>500 van ness ave.</Address><City>san francisco</City><Cuisine>american</Cuisine><Cluster>515</Cluster></Restaurant>
<Restaurant><Name>stoyanof's cafe</Name><Address>1240 9th ave.</Address><City>san francisco</City><Cuisine>greek and middle eastern</Cuisine><Cluster>516</Cluster></Restaurant>
<Restaurant><Name>straits cafe</Name><Address>3300 geary blvd.</Address><City>san francisco</City><Cuisine>asian</Cuisine><Cluster>517</Cluster></Restaurant>
<Restaurant><Name>suppenkuche</Name><Address>601 hayes st.</Address><City>san francisco</City><Cuisine>russian/german</Cuisine><Cluster>518</Cluster></Restaurant>
<Restaurant><Name>tadich grill</Name><Address>240 california st.</Address><City>san francisco</City><Cuisine>seafood</Cuisine><Cluster>519</Cluster></Restaurant>
<Restaurant><Name>the heights</Name><Address>3235 sacramento st.</Address><City>san francisco</City><Cuisine>french</Cuisine><Cluster>520</Cluster></Restaurant>
<Restaurant><Name>thepin</Name><Address>298 gough st.</Address><City>san francisco</City><Cuisine>asian</Cuisine><Cluster>521</Cluster></Restaurant>
<Restaurant><Name>ton kiang</Name><Address>3148 geary blvd.</Address><City>san francisco</City><Cuisine>asian</Cuisine><Cluster>522</Cluster></Restaurant>
<Restaurant><Name>vertigo</Name><Address>600 montgomery st.</Address><City>san francisco</City><Cuisine>mediterranean</Cuisine><Cluster>523</Cluster></Restaurant>
<Restaurant><Name>vivande porta via</Name><Address>2125 fillmore st.</Address><City>san francisco</City><Cuisine>italian</Cuisine><Cluster>524</Cluster></Restaurant>
<Restaurant><Name>vivande ristorante</Name><Address>670 golden gate ave.</Address><City>san francisco</City><Cuisine>italian</Cuisine><Cluster>525</Cluster></Restaurant>
<Restaurant><Name>world wrapps</Name><Address>2257 chestnut st.</Address><City>san francisco</City><Cuisine>american</Cuisine><Cluster>526</Cluster></Restaurant>
<Restaurant><Name>wu kong</Name><Address>101 spear st.</Address><City>san francisco</City><Cuisine>asian</Cuisine><Cluster>527</Cluster></Restaurant>
<Restaurant><Name>yank sing</Name><Address>427 battery st.</Address><City>san francisco</City><Cuisine>asian</Cuisine><Cluster>528</Cluster></Restaurant>
<Restaurant><Name>yaya cuisine</Name><Address>1220 9th ave.</Address><City>san francisco</City><Cuisine>greek and middle eastern</Cuisine><Cluster>529</Cluster></Restaurant>
<Restaurant><Name>yoyo tsumami bistro</Name><Address>1611 post st.</Address><City>san francisco</City><Cuisine>french</Cuisine><Cluster>530</Cluster></Restaurant>
<Restaurant><Name>zarzuela</Name><Address>2000 hyde st.</Address><City>san francisco</City><Cuisine>mexican/latin american/spanish</Cuisine><Cluster>531</Cluster></Restaurant>
<Restaurant><Name><![CDATA[zuni cafe & grill]]></Name><Address>1658 market st.</Address><City>san francisco</City><Cuisine>mediterranean</Cuisine><Cluster>532</Cluster></Restaurant>
<Restaurant><Name>apple pan  the</Name><Address>10801 w. pico blvd.</Address><City>west la</City><Cuisine>american</Cuisine><Cluster>534</Cluster></Restaurant>
<Restaurant><Name>asahi ramen</Name><Address>2027 sawtelle blvd.</Address><City>west la</City><Cuisine>noodle shops</Cuisine><Cluster>535</Cluster></Restaurant>
<Restaurant><Name>baja fresh</Name><Address>3345 kimber dr.</Address><City>westlake village</City><Cuisine>mexican</Cuisine><Cluster>536</Cluster></Restaurant>
<Restaurant><Name>belvedere  the</Name><Address>9882 little santa monica blvd.</Address><City>beverly hills</City><Cuisine>pacific new wave</Cuisine><Cluster>537</Cluster></Restaurant>
<Restaurant><Name>benita's frites</Name><Address>1433 third st. promenade</Address><City>santa monica</City><Cuisine>fast food</Cuisine><Cluster>538</Cluster></Restaurant>
<Restaurant><Name>bernard's</Name><Address>515 s. olive st.</Address><City>los angeles</City><Cuisine>continental</Cuisine><Cluster>539</Cluster></Restaurant>
<Restaurant><Name>bistro 45</Name><Address>45 s. mentor ave.</Address><City>pasadena</City><Cuisine>californian</Cuisine><Cluster>540</Cluster></Restaurant>
<Restaurant><Name>brent's deli</Name><Address>19565 parthenia ave.</Address><City>northridge</City><Cuisine>delis</Cuisine><Cluster>541</Cluster></Restaurant>
<Restaurant><Name>brighton coffee shop</Name><Address>9600 brighton way</Address><City>beverly hills</City><Cuisine>coffee shops</Cuisine><Cluster>542</Cluster></Restaurant>
<Restaurant><Name>bristol farms market cafe</Name><Address>1570 rosecrans ave. s.</Address><City>pasadena</City><Cuisine>californian</Cuisine><Cluster>543</Cluster></Restaurant>
<Restaurant><Name>bruno's</Name><Address>3838 centinela ave.</Address><City>mar vista</City><Cuisine>italian</Cuisine><Cluster>544</Cluster></Restaurant>
<Restaurant><Name>cafe '50s</Name><Address>838 lincoln blvd.</Address><City>venice</City><Cuisine>american</Cuisine><Cluster>545</Cluster></Restaurant>
<Restaurant><Name>cafe blanc</Name><Address>9777 little santa monica blvd.</Address><City>beverly hills</City><Cuisine>pacific new wave</Cuisine><Cluster>546</Cluster></Restaurant>
<Restaurant><Name>cassell's</Name><Address>3266 w. sixth st.</Address><City>la</City><Cuisine>hamburgers</Cuisine><Cluster>547</Cluster></Restaurant>
<Restaurant><Name>chez melange</Name><Address>1716 pch</Address><City>redondo beach</City><Cuisine>eclectic</Cuisine><Cluster>548</Cluster></Restaurant>
<Restaurant><Name>diaghilev</Name><Address>1020 n. san vicente blvd.</Address><City>w. hollywood</City><Cuisine>russian</Cuisine><Cluster>549</Cluster></Restaurant>
<Restaurant><Name>don antonio's</Name><Address>1136 westwood blvd.</Address><City>westwood</City><Cuisine>italian</Cuisine><Cluster>550</Cluster></Restaurant>
<Restaurant><Name>duke's</Name><Address>8909 sunset blvd.</Address><City>w. hollywood</City><Cuisine>coffee shops</Cuisine><Cluster>551</Cluster></Restaurant>
<Restaurant><Name>falafel king</Name><Address>1059 broxton ave.</Address><City>westwood</City><Cuisine>middle eastern</Cuisine><Cluster>552</Cluster></Restaurant>
<Restaurant><Name>feast from the east</Name><Address>1949 westwood blvd.</Address><City>west la</City><Cuisine>chinese</Cuisine><Cluster>553</Cluster></Restaurant>
<Restaurant><Name>gumbo pot  the</Name><Address>6333 w. third st.</Address><City>la</City><Cuisine>cajun/creole</Cuisine><Cluster>554</Cluster></Restaurant>
<Restaurant><Name>hollywood hills coffee shop</Name><Address>6145 franklin ave.</Address><City>hollywood</City><Cuisine>coffee shops</Cuisine><Cluster>555</Cluster></Restaurant>
<Restaurant><Name>indo cafe</Name><Address>10428 1/2 national blvd.</Address><City>la</City><Cuisine>indonesian</Cuisine><Cluster>556</Cluster></Restaurant>
<Restaurant><Name>jan's family restaurant</Name><Address>8424 beverly blvd.</Address><City>la</City><Cuisine>coffee shops</Cuisine><Cluster>557</Cluster></Restaurant>
<Restaurant><Name>jiraffe</Name><Address>502 santa monica blvd</Address><City>santa monica</City><Cuisine>californian</Cuisine><Cluster>558</Cluster></Restaurant>
<Restaurant><Name>jody maroni's sausage kingdom</Name><Address>2011 ocean front walk</Address><City>venice</City><Cuisine>hot dogs</Cuisine><Cluster>559</Cluster></Restaurant>
<Restaurant><Name>joe's</Name><Address>1023 abbot kinney blvd.</Address><City>venice</City><Cuisine>american (new)</Cuisine><Cluster>560</Cluster></Restaurant>
<Restaurant><Name>john o'groats</Name><Address>10516 w. pico blvd.</Address><City>west la</City><Cuisine>coffee shops</Cuisine><Cluster>561</Cluster></Restaurant>
<Restaurant><Name>johnnie's pastrami</Name><Address>4017 s. sepulveda blvd.</Address><City>culver city</City><Cuisine>delis</Cuisine><Cluster>562</Cluster></Restaurant>
<Restaurant><Name>johnny reb's southern smokehouse</Name><Address>4663 long beach blvd.</Address><City>long beach</City><Cuisine>southern/soul</Cuisine><Cluster>563</Cluster></Restaurant>
<Restaurant><Name>johnny rockets (la)</Name><Address>7507 melrose ave.</Address><City>la</City><Cuisine>american</Cuisine><Cluster>564</Cluster></Restaurant>
<Restaurant><Name>killer shrimp</Name><Address>4000 colfax ave.</Address><City>studio city</City><Cuisine>seafood</Cuisine><Cluster>565</Cluster></Restaurant>
<Restaurant><Name>kokomo cafe</Name><Address>6333 w. third st.</Address><City>la</City><Cuisine>american</Cuisine><Cluster>566</Cluster></Restaurant>
<Restaurant><Name>koo koo roo</Name><Address>8393 w. beverly blvd.</Address><City>la</City><Cuisine>chicken</Cuisine><Cluster>567</Cluster></Restaurant>
<Restaurant><Name>la cachette</Name><Address>10506 little santa monica blvd.</Address><City>century city</City><Cuisine>french (new)</Cuisine><Cluster>568</Cluster></Restaurant>
<Restaurant><Name>la salsa (la)</Name><Address>22800 pch</Address><City>malibu</City><Cuisine>mexican</Cuisine><Cluster>569</Cluster></Restaurant>
<Restaurant><Name>la serenata de garibaldi</Name><Address>1842 e. first</Address><City>st. boyle hts.</City><Cuisine>mexican/tex-mex</Cuisine><Cluster>570</Cluster></Restaurant>
<Restaurant><Name>langer's</Name><Address>704 s. alvarado st.</Address><City>la</City><Cuisine>delis</Cuisine><Cluster>571</Cluster></Restaurant>
<Restaurant><Name>local nochol</Name><Address>30869 thousand oaks blvd.</Address><City>westlake village</City><Cuisine>health food</Cuisine><Cluster>572</Cluster></Restaurant>
<Restaurant><Name>main course  the</Name><Address>10509 w. pico blvd.</Address><City>rancho park</City><Cuisine>american</Cuisine><Cluster>573</Cluster></Restaurant>
<Restaurant><Name><![CDATA[mani's bakery & espresso bar]]></Name><Address>519 s. fairfax ave.</Address><City>la</City><Cuisine>desserts</Cuisine><Cluster>574</Cluster></Restaurant>
<Restaurant><Name>martha's</Name><Address>22nd street grill 25 22nd</Address><City>st. hermosa beach</City><Cuisine>american</Cuisine><Cluster>575</Cluster></Restaurant>
<Restaurant><Name>maxwell's cafe</Name><Address>13329 washington blvd.</Address><City>marina del rey</City><Cuisine>american</Cuisine><Cluster>576</Cluster></Restaurant>
<Restaurant><Name>michael's (los angeles)</Name><Address>1147 third st.</Address><City>santa monica</City><Cuisine>californian</Cuisine><Cluster>577</Cluster></Restaurant>
<Restaurant><Name>mishima</Name><Address>8474 w. third st.</Address><City>la</City><Cuisine>noodle shops</Cuisine><Cluster>578</Cluster></Restaurant>
<Restaurant><Name>mo better meatty meat</Name><Address>7261 melrose ave.</Address><City>la</City><Cuisine>hamburgers</Cuisine><Cluster>579</Cluster></Restaurant>
<Restaurant><Name>mulberry st.</Name><Address>17040 ventura blvd.</Address><City>encino</City><Cuisine>pizza</Cuisine><Cluster>580</Cluster></Restaurant>
<Restaurant><Name>ocean park cafe</Name><Address>3117 ocean park blvd.</Address><City>santa monica</City><Cuisine>american</Cuisine><Cluster>581</Cluster></Restaurant>
<Restaurant><Name>ocean star</Name><Address>145 n. atlantic blvd.</Address><City>monterey park</City><Cuisine>seafood</Cuisine><Cluster>582</Cluster></Restaurant>
<Restaurant><Name>original pantry bakery</Name><Address>875 s. figueroa st. downtown</Address><City>la</City><Cuisine>diners</Cuisine><Cluster>583</Cluster></Restaurant>
<Restaurant><Name>parkway grill</Name><Address>510 s. arroyo pkwy.</Address><City>pasadena</City><Cuisine>californian</Cuisine><Cluster>584</Cluster></Restaurant>
<Restaurant><Name>pho hoa</Name><Address>642 broadway</Address><City>chinatown</City><Cuisine>vietnamese</Cuisine><Cluster>585</Cluster></Restaurant>
<Restaurant><Name>pink's famous chili dogs</Name><Address>709 n. la brea ave.</Address><City>la</City><Cuisine>hot dogs</Cuisine><Cluster>586</Cluster></Restaurant>
<Restaurant><Name>poquito mas</Name><Address>2635 w. olive ave.</Address><City>burbank</City><Cuisine>mexican</Cuisine><Cluster>587</Cluster></Restaurant>
<Restaurant><Name>r-23</Name><Address>923 e. third st.</Address><City>los angeles</City><Cuisine>japanese</Cuisine><Cluster>588</Cluster></Restaurant>
<Restaurant><Name>rae's</Name><Address>2901 pico blvd.</Address><City>santa monica</City><Cuisine>diners</Cuisine><Cluster>589</Cluster></Restaurant>
<Restaurant><Name>rubin's red hots</Name><Address>15322 ventura blvd.</Address><City>encino</City><Cuisine>hot dogs</Cuisine><Cluster>590</Cluster></Restaurant>
<Restaurant><Name>ruby's (la)</Name><Address>45 s. fair oaks ave.</Address><City>pasadena</City><Cuisine>diners</Cuisine><Cluster>591</Cluster></Restaurant>
<Restaurant><Name>russell's burgers</Name><Address>1198 pch</Address><City>seal beach</City><Cuisine>hamburgers</Cuisine><Cluster>592</Cluster></Restaurant>
<Restaurant><Name>ruth's chris steak house (los angeles)</Name><Address>224 s. beverly dr.</Address><City>beverly hills</City><Cuisine>steakhouses</Cuisine><Cluster>593</Cluster></Restaurant>
<Restaurant><Name>shiro</Name><Address>1505 mission st. s.</Address><City>pasadena</City><Cuisine>pacific new wave</Cuisine><Cluster>594</Cluster></Restaurant>
<Restaurant><Name>sushi nozawa</Name><Address>11288 ventura blvd.</Address><City>studio city</City><Cuisine>japanese</Cuisine><Cluster>595</Cluster></Restaurant>
<Restaurant><Name>sweet lady jane</Name><Address>8360 melrose ave.</Address><City>la</City><Cuisine>desserts</Cuisine><Cluster>596</Cluster></Restaurant>
<Restaurant><Name>taiko</Name><Address>11677 san vicente blvd.</Address><City>brentwood</City><Cuisine>noodle shops</Cuisine><Cluster>597</Cluster></Restaurant>
<Restaurant><Name>tommy's</Name><Address>2575 beverly blvd.</Address><City>la</City><Cuisine>hamburgers</Cuisine><Cluster>598</Cluster></Restaurant>
<Restaurant><Name>uncle bill's pancake house</Name><Address>1305 highland ave.</Address><City>manhattan beach</City><Cuisine>diners</Cuisine><Cluster>599</Cluster></Restaurant>
<Restaurant><Name>water grill</Name><Address>544 s. grand ave.</Address><City>los angeles</City><Cuisine>seafood</Cuisine><Cluster>600</Cluster></Restaurant>
<Restaurant><Name>zankou chicken</Name><Address>1415 e. colorado st.</Address><City>glendale</City><Cuisine>middle eastern</Cuisine><Cluster>601</Cluster></Restaurant>
<Restaurant><Name>afghan kebab house</Name><Address>764 ninth ave.</Address><City>new york city</City><Cuisine>afghan</Cuisine><Cluster>602</Cluster></Restaurant>
<Restaurant><Name>arcadia</Name><Address>21 e. 62nd st.</Address><City>new york city</City><Cuisine>american (new)</Cuisine><Cluster>603</Cluster></Restaurant>
<Restaurant><Name>benny's burritos</Name><Address>93 ave. a</Address><City>new york city</City><Cuisine>mexican</Cuisine><Cluster>604</Cluster></Restaurant>
<Restaurant><Name>cafe con leche</Name><Address>424 amsterdam ave.</Address><City>new york city</City><Cuisine>cuban</Cuisine><Cluster>605</Cluster></Restaurant>
<Restaurant><Name>corner bistro</Name><Address>331 w. fourth st.</Address><City>new york city</City><Cuisine>hamburgers</Cuisine><Cluster>606</Cluster></Restaurant>
<Restaurant><Name>cucina della fontana</Name><Address>368 bleecker st.</Address><City>new york city</City><Cuisine>italian</Cuisine><Cluster>607</Cluster></Restaurant>
<Restaurant><Name>cucina di pesce</Name><Address>87 e. fourth st.</Address><City>new york city</City><Cuisine>seafood</Cuisine><Cluster>608</Cluster></Restaurant>
<Restaurant><Name>darbar</Name><Address>44 w. 56th st.</Address><City>new york city</City><Cuisine>indian</Cuisine><Cluster>609</Cluster></Restaurant>
<Restaurant><Name>ej's luncheonette</Name><Address>432 sixth ave.</Address><City>new york city</City><Cuisine>diners</Cuisine><Cluster>610</Cluster></Restaurant>
<Restaurant><Name>edison cafe</Name><Address>228 w. 47th st.</Address><City>new york city</City><Cuisine>diners</Cuisine><Cluster>611</Cluster></Restaurant>
<Restaurant><Name>elias corner</Name><Address>24-02 31st st.</Address><City>queens</City><Cuisine>greek</Cuisine><Cluster>612</Cluster></Restaurant>
<Restaurant><Name>good enough to eat</Name><Address>483 amsterdam ave.</Address><City>new york city</City><Cuisine>american</Cuisine><Cluster>613</Cluster></Restaurant>
<Restaurant><Name>gray's papaya</Name><Address>2090 broadway</Address><City>new york city</City><Cuisine>hot dogs</Cuisine><Cluster>614</Cluster></Restaurant>
<Restaurant><Name>il mulino</Name><Address>86 w. third st.</Address><City>new york city</City><Cuisine>italian</Cuisine><Cluster>615</Cluster></Restaurant>
<Restaurant><Name>jackson diner</Name><Address>37-03 74th st.</Address><City>queens</City><Cuisine>indian</Cuisine><Cluster>616</Cluster></Restaurant>
<Restaurant><Name>joe's shanghai</Name><Address>9 pell st.</Address><City>queens</City><Cuisine>chinese</Cuisine><Cluster>617</Cluster></Restaurant>
<Restaurant><Name>john's pizzeria</Name><Address>48 w. 65th st.</Address><City>new york city</City><Cuisine>pizza</Cuisine><Cluster>618</Cluster></Restaurant>
<Restaurant><Name><![CDATA[kelley & ping]]></Name><Address>127 greene st.</Address><City>new york city</City><Cuisine>pan-asian</Cuisine><Cluster>619</Cluster></Restaurant>
<Restaurant><Name>kiev</Name><Address>117 second ave.</Address><City>new york city</City><Cuisine>ukrainian</Cuisine><Cluster>620</Cluster></Restaurant>
<Restaurant><Name>kuruma zushi</Name><Address>2nd fl.</Address><City>new york city</City><Cuisine>japanese</Cuisine><Cluster>621</Cluster></Restaurant>
<Restaurant><Name>la caridad</Name><Address>2199 broadway</Address><City>new york city</City><Cuisine>cuban</Cuisine><Cluster>622</Cluster></Restaurant>
<Restaurant><Name>la grenouille</Name><Address>3 e. 52nd st.</Address><City>new york city</City><Cuisine>french (classic)</Cuisine><Cluster>623</Cluster></Restaurant>
<Restaurant><Name>lemongrass grill</Name><Address>61a seventh ave.</Address><City>brooklyn</City><Cuisine>thai</Cuisine><Cluster>624</Cluster></Restaurant>
<Restaurant><Name>lombardi's</Name><Address>32 spring st.</Address><City>new york city</City><Cuisine>pizza</Cuisine><Cluster>625</Cluster></Restaurant>
<Restaurant><Name>marnie's noodle shop</Name><Address>466 hudson st.</Address><City>new york city</City><Cuisine>asian</Cuisine><Cluster>626</Cluster></Restaurant>
<Restaurant><Name>menchanko-tei</Name><Address>39 w. 55th st.</Address><City>new york city</City><Cuisine>japanese</Cuisine><Cluster>627</Cluster></Restaurant>
<Restaurant><Name>mitali east-west</Name><Address>296 bleecker st.</Address><City>new york city</City><Cuisine>indian</Cuisine><Cluster>628</Cluster></Restaurant>
<Restaurant><Name>monsoon (ny)</Name><Address>435 amsterdam ave.</Address><City>new york city</City><Cuisine>thai</Cuisine><Cluster>629</Cluster></Restaurant>
<Restaurant><Name>moustache</Name><Address>405 atlantic ave.</Address><City>brooklyn</City><Cuisine>middle eastern</Cuisine><Cluster>630</Cluster></Restaurant>
<Restaurant><Name>nobu</Name><Address>105 hudson st.</Address><City>new york city</City><Cuisine>japanese</Cuisine><Cluster>631</Cluster></Restaurant>
<Restaurant><Name>one if by land  tibs</Name><Address>17 barrow st.</Address><City>new york city</City><Cuisine>continental</Cuisine><Cluster>632</Cluster></Restaurant>
<Restaurant><Name>oyster bar</Name><Address>lower level</Address><City>new york city</City><Cuisine>seafood</Cuisine><Cluster>633</Cluster></Restaurant>
<Restaurant><Name>palm</Name><Address>837 second ave.</Address><City>new york city</City><Cuisine>steakhouses</Cuisine><Cluster>634</Cluster></Restaurant>
<Restaurant><Name>palm too</Name><Address>840 second ave.</Address><City>new york city</City><Cuisine>steakhouses</Cuisine><Cluster>635</Cluster></Restaurant>
<Restaurant><Name>patsy's pizza</Name><Address>19 old fulton st.</Address><City>brooklyn</City><Cuisine>pizza</Cuisine><Cluster>636</Cluster></Restaurant>
<Restaurant><Name>peter luger steak house</Name><Address>178 broadway</Address><City>brooklyn</City><Cuisine>steakhouses</Cuisine><Cluster>637</Cluster></Restaurant>
<Restaurant><Name>rose of india</Name><Address>308 e. sixth st.</Address><City>new york city</City><Cuisine>indian</Cuisine><Cluster>638</Cluster></Restaurant>
<Restaurant><Name>sam's noodle shop</Name><Address>411 third ave.</Address><City>new york city</City><Cuisine>chinese</Cuisine><Cluster>639</Cluster></Restaurant>
<Restaurant><Name>sarabeth's</Name><Address>1295 madison ave.</Address><City>new york city</City><Cuisine>american</Cuisine><Cluster>640</Cluster></Restaurant>
<Restaurant><Name>sparks steak house</Name><Address>210 e. 46th st.</Address><City>new york city</City><Cuisine>steakhouses</Cuisine><Cluster>641</Cluster></Restaurant>
<Restaurant><Name>stick to your ribs</Name><Address>5-16 51st ave.</Address><City>queens</City><Cuisine>bbq</Cuisine><Cluster>642</Cluster></Restaurant>
<Restaurant><Name>sushisay</Name><Address>38 e. 51st st.</Address><City>new york city</City><Cuisine>japanese</Cuisine><Cluster>643</Cluster></Restaurant>
<Restaurant><Name>sylvia's</Name><Address>328 lenox ave.</Address><City>new york city</City><Cuisine>southern/soul</Cuisine><Cluster>644</Cluster></Restaurant>
<Restaurant><Name>szechuan hunan cottage</Name><Address>1588 york ave.</Address><City>new york city</City><Cuisine>chinese</Cuisine><Cluster>645</Cluster></Restaurant>
<Restaurant><Name>szechuan kitchen</Name><Address>1460 first ave.</Address><City>new york city</City><Cuisine>chinese</Cuisine><Cluster>646</Cluster></Restaurant>
<Restaurant><Name>teresa's</Name><Address>80 montague st.</Address><City>queens</City><Cuisine>polish</Cuisine><Cluster>647</Cluster></Restaurant>
<Restaurant><Name>thai house cafe</Name><Address>151 hudson st.</Address><City>new york city</City><Cuisine>thai</Cuisine><Cluster>648</Cluster></Restaurant>
<Restaurant><Name>thailand restaurant</Name><Address>106 bayard st.</Address><City>new york city</City><Cuisine>thai</Cuisine><Cluster>649</Cluster></Restaurant>
<Restaurant><Name>veselka</Name><Address>144 second ave.</Address><City>new york city</City><Cuisine>ukrainian</Cuisine><Cluster>650</Cluster></Restaurant>
<Restaurant><Name>westside cottage</Name><Address>689 ninth ave.</Address><City>new york city</City><Cuisine>chinese</Cuisine><Cluster>651</Cluster></Restaurant>
<Restaurant><Name>windows on the world</Name><Address>107th fl.</Address><City>new york city</City><Cuisine>eclectic</Cuisine><Cluster>652</Cluster></Restaurant>
<Restaurant><Name>wollensky's grill</Name><Address>205 e. 49th st.</Address><City>new york city</City><Cuisine>steakhouses</Cuisine><Cluster>653</Cluster></Restaurant>
<Restaurant><Name>yama</Name><Address>122 e. 17th st.</Address><City>new york city</City><Cuisine>japanese</Cuisine><Cluster>654</Cluster></Restaurant>
<Restaurant><Name>zarela</Name><Address>953 second ave.</Address><City>new york city</City><Cuisine>mexican</Cuisine><Cluster>655</Cluster></Restaurant>
<Restaurant><Name>andre's french restaurant</Name><Address>401 s. 6th st.</Address><City>las vegas</City><Cuisine>french (classic)</Cuisine><Cluster>656</Cluster></Restaurant>
<Restaurant><Name>buccaneer bay club</Name><Address>3300 las vegas blvd. s.</Address><City>las vegas</City><Cuisine>continental</Cuisine><Cluster>657</Cluster></Restaurant>
<Restaurant><Name>buzio's in the rio</Name><Address>3700 w. flamingo rd.</Address><City>las vegas</City><Cuisine>seafood</Cuisine><Cluster>658</Cluster></Restaurant>
<Restaurant><Name>emeril's new orleans fish house</Name><Address>3799 las vegas blvd. s.</Address><City>las vegas</City><Cuisine>seafood</Cuisine><Cluster>659</Cluster></Restaurant>
<Restaurant><Name><![CDATA[fiore rotisserie & grille]]></Name><Address>3700 w. flamingo rd.</Address><City>las vegas</City><Cuisine>italian</Cuisine><Cluster>660</Cluster></Restaurant>
<Restaurant><Name>hugo's cellar</Name><Address>202 e. fremont st.</Address><City>las vegas</City><Cuisine>continental</Cuisine><Cluster>661</Cluster></Restaurant>
<Restaurant><Name>madame ching's</Name><Address>3300 las vegas blvd. s.</Address><City>las vegas</City><Cuisine>asian</Cuisine><Cluster>662</Cluster></Restaurant>
<Restaurant><Name>mayflower cuisinier</Name><Address>4750 w. sahara ave.</Address><City>las vegas</City><Cuisine>chinese</Cuisine><Cluster>663</Cluster></Restaurant>
<Restaurant><Name>michael's (las vegas)</Name><Address>3595 las vegas blvd. s.</Address><City>las vegas</City><Cuisine>continental</Cuisine><Cluster>664</Cluster></Restaurant>
<Restaurant><Name>monte carlo</Name><Address>3145 las vegas blvd. s.</Address><City>las vegas</City><Cuisine>french (new)</Cuisine><Cluster>665</Cluster></Restaurant>
<Restaurant><Name>moongate</Name><Address>3400 las vegas blvd. s.</Address><City>las vegas</City><Cuisine>chinese</Cuisine><Cluster>666</Cluster></Restaurant>
<Restaurant><Name>morton's of chicago (las vegas)</Name><Address>3200 las vegas blvd. s.</Address><City>las vegas</City><Cuisine>steakhouses</Cuisine><Cluster>667</Cluster></Restaurant>
<Restaurant><Name>nicky blair's</Name><Address>3925 paradise rd.</Address><City>las vegas</City><Cuisine>italian</Cuisine><Cluster>668</Cluster></Restaurant>
<Restaurant><Name>piero's restaurant</Name><Address>355 convention center dr.</Address><City>las vegas</City><Cuisine>italian</Cuisine><Cluster>669</Cluster></Restaurant>
<Restaurant><Name>spago (las vegas)</Name><Address>3500 las vegas blvd. s.</Address><City>las vegas</City><Cuisine>californian</Cuisine><Cluster>670</Cluster></Restaurant>
<Restaurant><Name>steakhouse  the</Name><Address>128 e. fremont st.</Address><City>las vegas</City><Cuisine>steakhouses</Cuisine><Cluster>671</Cluster></Restaurant>
<Restaurant><Name>stefano's</Name><Address>129 fremont st.</Address><City>las vegas</City><Cuisine>italian</Cuisine><Cluster>672</Cluster></Restaurant>
<Restaurant><Name>sterling brunch</Name><Address>3645 las vegas blvd. s.</Address><City>las vegas</City><Cuisine>eclectic</Cuisine><Cluster>673</Cluster></Restaurant>
<Restaurant><Name>tre visi</Name><Address>3799 las vegas blvd. s.</Address><City>las vegas</City><Cuisine>italian</Cuisine><Cluster>674</Cluster></Restaurant>
<Restaurant><Name>103 west</Name><Address>103 w. paces ferry rd.</Address><City>atlanta</City><Cuisine>continental</Cuisine><Cluster>675</Cluster></Restaurant>
<Restaurant><Name>alon's at the terrace</Name><Address>659 peachtree st.</Address><City>atlanta</City><Cuisine>sandwiches</Cuisine><Cluster>676</Cluster></Restaurant>
<Restaurant><Name>baker's cajun cafe</Name><Address>1134 euclid ave.</Address><City>atlanta</City><Cuisine>cajun/creole</Cuisine><Cluster>677</Cluster></Restaurant>
<Restaurant><Name>barbecue kitchen</Name><Address>1437 virginia ave.</Address><City>atlanta</City><Cuisine>bbq</Cuisine><Cluster>678</Cluster></Restaurant>
<Restaurant><Name>bistro  the</Name><Address>56 e. andrews dr. nw</Address><City>atlanta</City><Cuisine>french bistro</Cuisine><Cluster>679</Cluster></Restaurant>
<Restaurant><Name><![CDATA[bobby & june's kountry kitchen]]></Name><Address>375 14th st.</Address><City>atlanta</City><Cuisine>southern/soul</Cuisine><Cluster>680</Cluster></Restaurant>
<Restaurant><Name>bradshaw's restaurant</Name><Address>2911 s. pharr court</Address><City>atlanta</City><Cuisine>southern/soul</Cuisine><Cluster>681</Cluster></Restaurant>
<Restaurant><Name>brookhaven cafe</Name><Address>4274 peachtree rd.</Address><City>atlanta</City><Cuisine>vegetarian</Cuisine><Cluster>682</Cluster></Restaurant>
<Restaurant><Name>cafe sunflower</Name><Address>5975 roswell rd.</Address><City>atlanta</City><Cuisine>health food</Cuisine><Cluster>683</Cluster></Restaurant>
<Restaurant><Name>canoe</Name><Address>4199 paces ferry rd.</Address><City>atlanta</City><Cuisine>american (new)</Cuisine><Cluster>684</Cluster></Restaurant>
<Restaurant><Name>carey's</Name><Address>1021 cobb pkwy. se</Address><City>marietta</City><Cuisine>hamburgers</Cuisine><Cluster>685</Cluster></Restaurant>
<Restaurant><Name>carey's corner</Name><Address>1215 powers ferry rd.</Address><City>marietta</City><Cuisine>hamburgers</Cuisine><Cluster>686</Cluster></Restaurant>
<Restaurant><Name>chops</Name><Address>70 w. paces ferry rd.</Address><City>atlanta</City><Cuisine>steakhouses</Cuisine><Cluster>687</Cluster></Restaurant>
<Restaurant><Name>chopstix</Name><Address>4279 roswell rd.</Address><City>atlanta</City><Cuisine>chinese</Cuisine><Cluster>688</Cluster></Restaurant>
<Restaurant><Name>deacon burton's soulfood restaurant</Name><Address>1029 edgewood ave. se</Address><City>atlanta</City><Cuisine>southern/soul</Cuisine><Cluster>689</Cluster></Restaurant>
<Restaurant><Name>eats</Name><Address>600 ponce de leon ave.</Address><City>atlanta</City><Cuisine>italian</Cuisine><Cluster>690</Cluster></Restaurant>
<Restaurant><Name>flying biscuit  the</Name><Address>1655 mclendon ave.</Address><City>atlanta</City><Cuisine>eclectic</Cuisine><Cluster>691</Cluster></Restaurant>
<Restaurant><Name>frijoleros</Name><Address>1031 peachtree st. ne</Address><City>atlanta</City><Cuisine>tex-mex</Cuisine><Cluster>692</Cluster></Restaurant>
<Restaurant><Name>greenwood's</Name><Address>1087 green st.</Address><City>roswell</City><Cuisine>southern/soul</Cuisine><Cluster>693</Cluster></Restaurant>
<Restaurant><Name>harold's barbecue</Name><Address>171 mcdonough blvd.</Address><City>atlanta</City><Cuisine>bbq</Cuisine><Cluster>694</Cluster></Restaurant>
<Restaurant><Name>havana sandwich shop</Name><Address>2905 buford hwy.</Address><City>atlanta</City><Cuisine>cuban</Cuisine><Cluster>695</Cluster></Restaurant>
<Restaurant><Name>house of chan</Name><Address>2469 cobb pkwy.</Address><City>smyrna</City><Cuisine>chinese</Cuisine><Cluster>696</Cluster></Restaurant>
<Restaurant><Name>indian delights</Name><Address>3675 satellite blvd.</Address><City>duluth</City><Cuisine>indian</Cuisine><Cluster>697</Cluster></Restaurant>
<Restaurant><Name>java jive</Name><Address>790 ponce de leon ave.</Address><City>atlanta</City><Cuisine>coffee shops</Cuisine><Cluster>698</Cluster></Restaurant>
<Restaurant><Name>johnny rockets (at)</Name><Address>2970 cobb pkwy.</Address><City>atlanta</City><Cuisine>american</Cuisine><Cluster>699</Cluster></Restaurant>
<Restaurant><Name>kalo's coffee house</Name><Address>1248 clairmont rd.</Address><City>decatur</City><Cuisine>coffeehouses</Cuisine><Cluster>700</Cluster></Restaurant>
<Restaurant><Name>la fonda latina</Name><Address>4427 roswell rd.</Address><City>atlanta</City><Cuisine>spanish</Cuisine><Cluster>701</Cluster></Restaurant>
<Restaurant><Name>lettuce souprise you (at)</Name><Address>3525 mall blvd.</Address><City>duluth</City><Cuisine>cafeterias</Cuisine><Cluster>702</Cluster></Restaurant>
<Restaurant><Name>majestic</Name><Address>1031 ponce de leon ave.</Address><City>atlanta</City><Cuisine>diners</Cuisine><Cluster>703</Cluster></Restaurant>
<Restaurant><Name>morton's of chicago (atlanta)</Name><Address>303 peachtree st. ne</Address><City>atlanta</City><Cuisine>steakhouses</Cuisine><Cluster>704</Cluster></Restaurant>
<Restaurant><Name>my thai</Name><Address>1248 clairmont rd.</Address><City>atlanta</City><Cuisine>thai</Cuisine><Cluster>705</Cluster></Restaurant>
<Restaurant><Name>nava</Name><Address>3060 peachtree rd.</Address><City>atlanta</City><Cuisine>southwestern</Cuisine><Cluster>706</Cluster></Restaurant>
<Restaurant><Name>nuevo laredo cantina</Name><Address>1495 chattahoochee ave. nw</Address><City>atlanta</City><Cuisine>mexican</Cuisine><Cluster>707</Cluster></Restaurant>
<Restaurant><Name>original pancake house (at)</Name><Address>4330 peachtree rd.</Address><City>atlanta</City><Cuisine>american</Cuisine><Cluster>708</Cluster></Restaurant>
<Restaurant><Name>palm  the (atlanta)</Name><Address>3391 peachtree rd. ne</Address><City>atlanta</City><Cuisine>steakhouses</Cuisine><Cluster>709</Cluster></Restaurant>
<Restaurant><Name>rainbow restaurant</Name><Address>2118 n. decatur rd.</Address><City>decatur</City><Cuisine>vegetarian</Cuisine><Cluster>710</Cluster></Restaurant>
<Restaurant><Name>ritz-carlton cafe (atlanta)</Name><Address>181 peachtree st.</Address><City>atlanta</City><Cuisine>american (new)</Cuisine><Cluster>711</Cluster></Restaurant>
<Restaurant><Name>riviera</Name><Address>519 e. paces ferry rd.</Address><City>atlanta</City><Cuisine>mediterranean</Cuisine><Cluster>712</Cluster></Restaurant>
<Restaurant><Name>silver skillet  the</Name><Address>200 14th st. nw</Address><City>atlanta</City><Cuisine>coffee shops</Cuisine><Cluster>713</Cluster></Restaurant>
<Restaurant><Name>soto</Name><Address>3330 piedmont rd.</Address><City>atlanta</City><Cuisine>japanese</Cuisine><Cluster>714</Cluster></Restaurant>
<Restaurant><Name>thelma's kitchen</Name><Address>764 marietta st. nw</Address><City>atlanta</City><Cuisine>cafeterias</Cuisine><Cluster>715</Cluster></Restaurant>
<Restaurant><Name>tortillas</Name><Address>774 ponce de leon ave. ne</Address><City>atlanta</City><Cuisine>tex-mex</Cuisine><Cluster>716</Cluster></Restaurant>
<Restaurant><Name><![CDATA[van gogh's restaurant & bar]]></Name><Address>70 w. crossville rd.</Address><City>roswell</City><Cuisine>american (new)</Cuisine><Cluster>717</Cluster></Restaurant>
<Restaurant><Name>veggieland</Name><Address>220 sandy springs circle</Address><City>atlanta</City><Cuisine>vegetarian</Cuisine><Cluster>718</Cluster></Restaurant>
<Restaurant><Name>white house restaurant</Name><Address>3172 peachtree rd. ne</Address><City>atlanta</City><Cuisine>diners</Cuisine><Cluster>719</Cluster></Restaurant>
<Restaurant><Name>zab-e-lee</Name><Address>4837 old national hwy.</Address><City>college park</City><Cuisine>thai</Cuisine><Cluster>720</Cluster></Restaurant>
<Restaurant><Name>bill's place</Name><Address>2315 clement st.</Address><City>san francisco</City><Cuisine>hamburgers</Cuisine><Cluster>721</Cluster></Restaurant>
<Restaurant><Name>cafe flore</Name><Address>2298 market st.</Address><City>san francisco</City><Cuisine>californian</Cuisine><Cluster>722</Cluster></Restaurant>
<Restaurant><Name>caffe greco</Name><Address>423 columbus ave.</Address><City>san francisco</City><Cuisine>continental</Cuisine><Cluster>723</Cluster></Restaurant>
<Restaurant><Name>campo santo</Name><Address>240 columbus ave.</Address><City>san francisco</City><Cuisine>mexican</Cuisine><Cluster>724</Cluster></Restaurant>
<Restaurant><Name>cha cha cha's</Name><Address>1805 haight st.</Address><City>san francisco</City><Cuisine>caribbean</Cuisine><Cluster>725</Cluster></Restaurant>
<Restaurant><Name>doidge's</Name><Address>2217 union st.</Address><City>san francisco</City><Cuisine>american</Cuisine><Cluster>726</Cluster></Restaurant>
<Restaurant><Name>dottie's true blue cafe</Name><Address>522 jones st.</Address><City>san francisco</City><Cuisine>diners</Cuisine><Cluster>727</Cluster></Restaurant>
<Restaurant><Name>dusit thai</Name><Address>3221 mission st.</Address><City>san francisco</City><Cuisine>thai</Cuisine><Cluster>728</Cluster></Restaurant>
<Restaurant><Name>ebisu</Name><Address>1283 ninth ave.</Address><City>san francisco</City><Cuisine>japanese</Cuisine><Cluster>729</Cluster></Restaurant>
<Restaurant><Name>emerald garden restaurant</Name><Address>1550 california st.</Address><City>san francisco</City><Cuisine>vietnamese</Cuisine><Cluster>730</Cluster></Restaurant>
<Restaurant><Name>eric's chinese restaurant</Name><Address>1500 church st.</Address><City>san francisco</City><Cuisine>chinese</Cuisine><Cluster>731</Cluster></Restaurant>
<Restaurant><Name>hamburger mary's</Name><Address>1582 folsom st.</Address><City>san francisco</City><Cuisine>hamburgers</Cuisine><Cluster>732</Cluster></Restaurant>
<Restaurant><Name>kelly's on trinity</Name><Address>333 bush st.</Address><City>san francisco</City><Cuisine>californian</Cuisine><Cluster>733</Cluster></Restaurant>
<Restaurant><Name>la cumbre</Name><Address>515 valencia st.</Address><City>san francisco</City><Cuisine>mexican</Cuisine><Cluster>734</Cluster></Restaurant>
<Restaurant><Name>la mediterranee</Name><Address>288 noe st.</Address><City>san francisco</City><Cuisine>mediterranean</Cuisine><Cluster>735</Cluster></Restaurant>
<Restaurant><Name>la taqueria</Name><Address>2889 mission st.</Address><City>san francisco</City><Cuisine>mexican</Cuisine><Cluster>736</Cluster></Restaurant>
<Restaurant><Name>mario's bohemian cigar store cafe</Name><Address>2209 polk st.</Address><City>san francisco</City><Cuisine>italian</Cuisine><Cluster>737</Cluster></Restaurant>
<Restaurant><Name>marnee thai</Name><Address>2225 irving st.</Address><City>san francisco</City><Cuisine>thai</Cuisine><Cluster>738</Cluster></Restaurant>
<Restaurant><Name>mel's drive-in</Name><Address>3355 geary st.</Address><City>san francisco</City><Cuisine>hamburgers</Cuisine><Cluster>739</Cluster></Restaurant>
<Restaurant><Name>mo's burgers</Name><Address>1322 grant st.</Address><City>san francisco</City><Cuisine>hamburgers</Cuisine><Cluster>740</Cluster></Restaurant>
<Restaurant><Name>phnom penh cambodian restaurant</Name><Address>631 larkin st.</Address><City>san francisco</City><Cuisine>cambodian</Cuisine><Cluster>741</Cluster></Restaurant>
<Restaurant><Name>roosevelt tamale parlor</Name><Address>2817 24th st.</Address><City>san francisco</City><Cuisine>mexican</Cuisine><Cluster>742</Cluster></Restaurant>
<Restaurant><Name><![CDATA[sally's cafe & bakery]]></Name><Address>300 de haro st.</Address><City>san francisco</City><Cuisine>american</Cuisine><Cluster>743</Cluster></Restaurant>
<Restaurant><Name>san francisco bbq</Name><Address>1328 18th st.</Address><City>san francisco</City><Cuisine>thai</Cuisine><Cluster>744</Cluster></Restaurant>
<Restaurant><Name>slanted door</Name><Address>584 valencia st.</Address><City>san francisco</City><Cuisine>vietnamese</Cuisine><Cluster>745</Cluster></Restaurant>
<Restaurant><Name>swan oyster depot</Name><Address>1517 polk st.</Address><City>san francisco</City><Cuisine>seafood</Cuisine><Cluster>746</Cluster></Restaurant>
<Restaurant><Name>thep phanom</Name><Address>400 waller st.</Address><City>san francisco</City><Cuisine>thai</Cuisine><Cluster>747</Cluster></Restaurant>
<Restaurant><Name>ti couz</Name><Address>3108 16th st.</Address><City>san francisco</City><Cuisine>french</Cuisine><Cluster>748</Cluster></Restaurant>
<Restaurant><Name>trio cafe</Name><Address>1870 fillmore st.</Address><City>san francisco</City><Cuisine>american</Cuisine><Cluster>749</Cluster></Restaurant>
<Restaurant><Name>tu lan</Name><Address>8 sixth st.</Address><City>san francisco</City><Cuisine>vietnamese</Cuisine><Cluster>750</Cluster></Restaurant>
<Restaurant><Name>vicolo pizzeria</Name><Address>201 ivy st.</Address><City>san francisco</City><Cuisine>pizza</Cuisine><Cluster>751</Cluster></Restaurant>
<Restaurant><Name>wa-ha-ka oaxaca mexican grill</Name><Address>2141 polk st.</Address><City>san francisco</City><Cuisine>mexican</Cuisine><Cluster>752</Cluster></Restaurant>
</xml>
}

Storage Default
{
<Data name="RestaurantDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Address</Value>
</Value>
<Value name="4">
<Value>City</Value>
</Value>
<Value name="5">
<Value>Cuisine</Value>
</Value>
<Value name="6">
<Value>Cluster</Value>
</Value>
<Value name="7">
<Value>PredictedCluster</Value>
</Value>
</Data>
<DataLocation>^ml.match.RestaurantD</DataLocation>
<DefaultData>RestaurantDefaultData</DefaultData>
<IdLocation>^ml.match.RestaurantD</IdLocation>
<IndexLocation>^ml.match.RestaurantI</IndexLocation>
<StreamLocation>^ml.match.RestaurantS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

