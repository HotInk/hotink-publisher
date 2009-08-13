// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var load_button_fix = function () {
	if(Prototype.Browser.Gecko) $$('button').each(function(bt){bt.setStyle({marginLeft: "-3px", marginRight: "-3px"});});
}

