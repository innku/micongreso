// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

jQuery(document).ready( function(){
	
	jQuery(document).ajaxSend(function(event, request, settings) {
	  if (typeof(AUTH_TOKEN) == "undefined") return;
	  settings.data = settings.data || "";
	  settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
	});
	
	jQuery("#news_abstract").apTextCounter({
	  maxCharacters: 300,
	  direction: "down",
	  tracker: "#chars_left",
	  trackerTemplate: "%s caracteres restantes"
	});
	
	jQuery('.datepicker').each(function(){
		jQuery(this).datepicker(jQuery.datepicker.regional['es']);
		jQuery(this).datepicker('option', 'altField', jQuery(this).next());
		jQuery(this).datepicker('option', 'altFormat', 'yy-mm-dd');
	});
	
	
});