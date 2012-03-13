<?php $currentid = $_REQUEST['currentid'] ; ?>
<h2>Comparaison d'un corpus</h2>
<script type="text/javascript" charset="utf-8">
	$("<?php echo '#'.$currentid ?>-accordion").accordion();
</script>
<div id="<?php echo $currentid ?>-accordion">
	<h3><a href="#">Section 1</a></h3>
	<div id="#<?php echo $currentid ?>-result">
		<table class="pompoview-table">
		<thead><tr><th></th><th><abbr title="corpus/test/3/other/output.py">1</abbr></th><th><abbr title="corpus/test/3/html.py">2</abbr></th><th><abbr title="corpus/test/3/tp.py">3</abbr></th><th><abbr title="corpus/test/3/plot.py">4</abbr></th><th><abbr title="corpus/test/1/Source/nuage.py">5</abbr></th><th><abbr title="corpus/test/3/other/tools.py">6</abbr></th><th><abbr title="corpus/test/1/Source/tp_1_2.py">7</abbr></th><th><abbr title="corpus/test/1/Source/cnt_char.py">8</abbr></th><th><abbr title="corpus/test/4/LTAL_1_2.py">9</abbr></th><th><abbr title="corpus/test/1/Source/graph.py">10</abbr></th><th><abbr title="corpus/test/5/TP_1_2.py">11</abbr></th><th><abbr title="corpus/test/2/tp_1-2.py">12</abbr></th><th><abbr title="corpus/test/6/script.py">13</abbr></th><th><abbr title="corpus/test/1/Source/tool_ltal.py">14</abbr></th><th><abbr title="corpus/test/4/Boitoutils.py">15</abbr></th><th><abbr title="corpus/test/5/Boitoutils.py">16</abbr></th></tr></thead>
		<tbody>
		<tr><th><abbr title="corpus/test/3/other/output.py">1</abbr></th><td style="background-color:hsl(0,100%,50%);"><abbr title="0.000000">0.00</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.963720">0.96</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.992340">0.99</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.955110">0.96</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.959620">0.96</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="0.995200">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="0.995870">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.986800">0.99</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.987410">0.99</abbr></td></tr>
		<tr><th><abbr title="corpus/test/3/html.py">2</abbr></th><td style="background-color:hsl(85,100%,50%);"><abbr title="0.963720">0.96</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.000000">0.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.953770">0.95</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.953810">0.95</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.970810">0.97</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.992400">0.99</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.947720">0.95</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.955220">0.96</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.968910">0.97</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.970350">0.97</abbr></td></tr>
		<tr><th><abbr title="corpus/test/3/tp.py">3</abbr></th><td style="background-color:hsl(102,100%,50%);"><abbr title="0.992340">0.99</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.000000">0.00</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.939280">0.94</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.938660">0.94</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.936640">0.94</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="0.995030">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="0.993950">0.99</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.986710">0.99</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.990830">0.99</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.964120">0.96</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.986630">0.99</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="0.994320">0.99</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.989240">0.99</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td></tr>
		<tr><th><abbr title="corpus/test/3/plot.py">4</abbr></th><td style="background-color:hsl(85,100%,50%);"><abbr title="0.955110">0.96</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.953770">0.95</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.939280">0.94</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.000000">0.00</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.974980">0.97</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.991760">0.99</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.980600">0.98</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.982900">0.98</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.980260">0.98</abbr></td><td style="background-color:hsl(51,100%,50%);"><abbr title="0.891650">0.89</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.984620">0.98</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.965950">0.97</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.965950">0.97</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.937870">0.94</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.937870">0.94</abbr></td></tr>
		<tr><th><abbr title="corpus/test/1/Source/nuage.py">5</abbr></th><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.953810">0.95</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.938660">0.94</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.974980">0.97</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.000000">0.00</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.971570">0.97</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.953970">0.95</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.950280">0.95</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.931560">0.93</abbr></td><td style="background-color:hsl(51,100%,50%);"><abbr title="0.843570">0.84</abbr></td><td style="background-color:hsl(51,100%,50%);"><abbr title="0.896530">0.90</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.953810">0.95</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.921370">0.92</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.921370">0.92</abbr></td></tr>
		<tr><th><abbr title="corpus/test/3/other/tools.py">6</abbr></th><td style="background-color:hsl(85,100%,50%);"><abbr title="0.959620">0.96</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.970810">0.97</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.936640">0.94</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.991760">0.99</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.971570">0.97</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.000000">0.00</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.970170">0.97</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.973650">0.97</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(34,100%,50%);"><abbr title="0.813120">0.81</abbr></td><td style="background-color:hsl(51,100%,50%);"><abbr title="0.860870">0.86</abbr></td><td style="background-color:hsl(51,100%,50%);"><abbr title="0.861400">0.86</abbr></td></tr>
		<tr><th><abbr title="corpus/test/1/Source/tp_1_2.py">7</abbr></th><td style="background-color:hsl(120,100%,50%);"><abbr title="0.995200">1.00</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.992400">0.99</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="0.995030">1.00</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.980600">0.98</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.953970">0.95</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.970170">0.97</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.000000">0.00</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.940540">0.94</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.919590">0.92</abbr></td><td style="background-color:hsl(34,100%,50%);"><abbr title="0.756320">0.76</abbr></td><td style="background-color:hsl(51,100%,50%);"><abbr title="0.843210">0.84</abbr></td><td style="background-color:hsl(51,100%,50%);"><abbr title="0.877130">0.88</abbr></td><td style="background-color:hsl(51,100%,50%);"><abbr title="0.887960">0.89</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.949260">0.95</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.965050">0.97</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.945620">0.95</abbr></td></tr>
		<tr><th><abbr title="corpus/test/1/Source/cnt_char.py">8</abbr></th><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="0.993950">0.99</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.982900">0.98</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.950280">0.95</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.940540">0.94</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.000000">0.00</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.929070">0.93</abbr></td><td style="background-color:hsl(34,100%,50%);"><abbr title="0.799060">0.80</abbr></td><td style="background-color:hsl(17,100%,50%);"><abbr title="0.650910">0.65</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.918890">0.92</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.925470">0.93</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.947190">0.95</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.978930">0.98</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.959200">0.96</abbr></td></tr>
		<tr><th><abbr title="corpus/test/4/LTAL_1_2.py">9</abbr></th><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.986710">0.99</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.980260">0.98</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.931560">0.93</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.919590">0.92</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.929070">0.93</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.000000">0.00</abbr></td><td style="background-color:hsl(17,100%,50%);"><abbr title="0.568800">0.57</abbr></td><td style="background-color:hsl(51,100%,50%);"><abbr title="0.843150">0.84</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.950270">0.95</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.968540">0.97</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.962850">0.96</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.970360">0.97</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.955010">0.96</abbr></td></tr>
		<tr><th><abbr title="corpus/test/1/Source/graph.py">10</abbr></th><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(51,100%,50%);"><abbr title="0.891650">0.89</abbr></td><td style="background-color:hsl(51,100%,50%);"><abbr title="0.843570">0.84</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(34,100%,50%);"><abbr title="0.756320">0.76</abbr></td><td style="background-color:hsl(34,100%,50%);"><abbr title="0.799060">0.80</abbr></td><td style="background-color:hsl(17,100%,50%);"><abbr title="0.568800">0.57</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.000000">0.00</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.555430">0.56</abbr></td><td style="background-color:hsl(34,100%,50%);"><abbr title="0.755720">0.76</abbr></td><td style="background-color:hsl(34,100%,50%);"><abbr title="0.815180">0.82</abbr></td><td style="background-color:hsl(51,100%,50%);"><abbr title="0.871170">0.87</abbr></td><td style="background-color:hsl(17,100%,50%);"><abbr title="0.663550">0.66</abbr></td><td style="background-color:hsl(17,100%,50%);"><abbr title="0.663550">0.66</abbr></td></tr>
		<tr><th><abbr title="corpus/test/5/TP_1_2.py">11</abbr></th><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.990830">0.99</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.984620">0.98</abbr></td><td style="background-color:hsl(51,100%,50%);"><abbr title="0.896530">0.90</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.973650">0.97</abbr></td><td style="background-color:hsl(51,100%,50%);"><abbr title="0.843210">0.84</abbr></td><td style="background-color:hsl(17,100%,50%);"><abbr title="0.650910">0.65</abbr></td><td style="background-color:hsl(51,100%,50%);"><abbr title="0.843150">0.84</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.555430">0.56</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.000000">0.00</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.941980">0.94</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.948700">0.95</abbr></td><td style="background-color:hsl(51,100%,50%);"><abbr title="0.892430">0.89</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.978460">0.98</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.967980">0.97</abbr></td></tr>
		<tr><th><abbr title="corpus/test/2/tp_1-2.py">12</abbr></th><td style="background-color:hsl(120,100%,50%);"><abbr title="0.995870">1.00</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.947720">0.95</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.964120">0.96</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.965950">0.97</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(51,100%,50%);"><abbr title="0.877130">0.88</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.918890">0.92</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.950270">0.95</abbr></td><td style="background-color:hsl(34,100%,50%);"><abbr title="0.755720">0.76</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.941980">0.94</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.000000">0.00</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.248780">0.25</abbr></td><td style="background-color:hsl(34,100%,50%);"><abbr title="0.720740">0.72</abbr></td><td style="background-color:hsl(17,100%,50%);"><abbr title="0.705380">0.71</abbr></td><td style="background-color:hsl(17,100%,50%);"><abbr title="0.669720">0.67</abbr></td></tr>
		<tr><th><abbr title="corpus/test/6/script.py">13</abbr></th><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.955220">0.96</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.986630">0.99</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.965950">0.97</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(51,100%,50%);"><abbr title="0.887960">0.89</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.925470">0.93</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.968540">0.97</abbr></td><td style="background-color:hsl(34,100%,50%);"><abbr title="0.815180">0.82</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.948700">0.95</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.248780">0.25</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.000000">0.00</abbr></td><td style="background-color:hsl(17,100%,50%);"><abbr title="0.708090">0.71</abbr></td><td style="background-color:hsl(17,100%,50%);"><abbr title="0.701100">0.70</abbr></td><td style="background-color:hsl(17,100%,50%);"><abbr title="0.658330">0.66</abbr></td></tr>
		<tr><th><abbr title="corpus/test/1/Source/tool_ltal.py">14</abbr></th><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="0.994320">0.99</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.953810">0.95</abbr></td><td style="background-color:hsl(34,100%,50%);"><abbr title="0.813120">0.81</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.949260">0.95</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.947190">0.95</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.962850">0.96</abbr></td><td style="background-color:hsl(51,100%,50%);"><abbr title="0.871170">0.87</abbr></td><td style="background-color:hsl(51,100%,50%);"><abbr title="0.892430">0.89</abbr></td><td style="background-color:hsl(34,100%,50%);"><abbr title="0.720740">0.72</abbr></td><td style="background-color:hsl(17,100%,50%);"><abbr title="0.708090">0.71</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.000000">0.00</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.545360">0.55</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.434870">0.43</abbr></td></tr>
		<tr><th><abbr title="corpus/test/4/Boitoutils.py">15</abbr></th><td style="background-color:hsl(102,100%,50%);"><abbr title="0.986800">0.99</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.968910">0.97</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.989240">0.99</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.937870">0.94</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.921370">0.92</abbr></td><td style="background-color:hsl(51,100%,50%);"><abbr title="0.860870">0.86</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.965050">0.97</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.978930">0.98</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.970360">0.97</abbr></td><td style="background-color:hsl(17,100%,50%);"><abbr title="0.663550">0.66</abbr></td><td style="background-color:hsl(102,100%,50%);"><abbr title="0.978460">0.98</abbr></td><td style="background-color:hsl(17,100%,50%);"><abbr title="0.705380">0.71</abbr></td><td style="background-color:hsl(17,100%,50%);"><abbr title="0.701100">0.70</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.545360">0.55</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.000000">0.00</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.165960">0.17</abbr></td></tr>
		<tr><th><abbr title="corpus/test/5/Boitoutils.py">16</abbr></th><td style="background-color:hsl(102,100%,50%);"><abbr title="0.987410">0.99</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.970350">0.97</abbr></td><td style="background-color:hsl(120,100%,50%);"><abbr title="1.000000">1.00</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.937870">0.94</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.921370">0.92</abbr></td><td style="background-color:hsl(51,100%,50%);"><abbr title="0.861400">0.86</abbr></td><td style="background-color:hsl(68,100%,50%);"><abbr title="0.945620">0.95</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.959200">0.96</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.955010">0.96</abbr></td><td style="background-color:hsl(17,100%,50%);"><abbr title="0.663550">0.66</abbr></td><td style="background-color:hsl(85,100%,50%);"><abbr title="0.967980">0.97</abbr></td><td style="background-color:hsl(17,100%,50%);"><abbr title="0.669720">0.67</abbr></td><td style="background-color:hsl(17,100%,50%);"><abbr title="0.658330">0.66</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.434870">0.43</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.165960">0.17</abbr></td><td style="background-color:hsl(0,100%,50%);"><abbr title="0.000000">0.00</abbr></td></tr>
		</tbody>
		</table>
	</div>
	<h3><a href="#">Section 2</a></h3>
	<div>
		<ul style="list-style:none;">
		<li><strong>1</strong>: corpus/test/3/other/output.py
		<li><strong>2</strong>: corpus/test/3/html.py
		<li><strong>3</strong>: corpus/test/3/tp.py
		<li><strong>4</strong>: corpus/test/3/plot.py
		<li><strong>5</strong>: corpus/test/1/Source/nuage.py
		<li><strong>6</strong>: corpus/test/3/other/tools.py
		<li><strong>7</strong>: corpus/test/1/Source/tp_1_2.py
		<li><strong>8</strong>: corpus/test/1/Source/cnt_char.py
		<li><strong>9</strong>: corpus/test/4/LTAL_1_2.py
		<li><strong>10</strong>: corpus/test/1/Source/graph.py
		<li><strong>11</strong>: corpus/test/5/TP_1_2.py
		<li><strong>12</strong>: corpus/test/2/tp_1-2.py
		<li><strong>13</strong>: corpus/test/6/script.py
		<li><strong>14</strong>: corpus/test/1/Source/tool_ltal.py
		<li><strong>15</strong>: corpus/test/4/Boitoutils.py
		<li><strong>16</strong>: corpus/test/5/Boitoutils.py
		</ul>
	</div>
	<h3><a href="#">Section 3</a></h3>
	<div>
		<p>
		Nam enim risus, molestie et, porta ac, aliquam ac, risus. Quisque lobortis.
		Phasellus pellentesque purus in massa. Aenean in pede. Phasellus ac libero
		ac tellus pellentesque semper. Sed ac felis. Sed commodo, magna quis
		lacinia ornare, quam ante aliquam nisi, eu iaculis leo purus venenatis dui.
		</p>
		<ul>
			<li>List item one</li>
			<li>List item two</li>
			<li>List item three</li>
		</ul>
	</div>
	<h3><a href="#">Section 4</a></h3>
	<div>
		<p>
		Cras dictum. Pellentesque habitant morbi tristique senectus et netus
		et malesuada fames ac turpis egestas. Vestibulum ante ipsum primis in
		faucibus orci luctus et ultrices posuere cubilia Curae; Aenean lacinia
		mauris vel est.
		</p>
		<p>
		Suspendisse eu nisl. Nullam ut libero. Integer dignissim consequat lectus.
		Class aptent taciti sociosqu ad litora torquent per conubia nostra, per
		inceptos himenaeos.
		</p>
	</div>
</div>