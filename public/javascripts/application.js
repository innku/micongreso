// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

$(document).ready( function(){
	
	$(document).ajaxSend(function(event, request, settings) {
	  if (typeof(AUTH_TOKEN) == "undefined") return;
	  settings.data = settings.data || "";
	  settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
	});
	
	
	if ($("body").hasClass("text_counter")) {
		$("#news_abstract").apTextCounter({
		  maxCharacters: 300,
		  direction: "down",
		  tracker: "#chars_left",
		  trackerTemplate: "%s caracteres restantes"
		});
	}
	
	$('.datepicker').each(function(){
		$(this).datepicker($.datepicker.regional['es']);
		$(this).datepicker('option', 'altField', $(this).next());
		$(this).datepicker('option', 'altFormat', 'yy-mm-dd');
	});
	
	
});