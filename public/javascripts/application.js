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
	
	$('.show_votes').click(function(){
		$(this).next().toggle();
		return false;
	})
	
	$('.absence').click(function(){
		if ($(this).is(':checked')) {
			$(this).parent().next().children().show();
		}
	})
	
	$('.justified').live('click', function(){
		if ($(this).is(':checked')) {
			$(this).parent().next().children().show();
		}	else {
			$(this).parent().next().children().hide().val("");
		}
	})
	
	if ($("body").hasClass("absences")) {
		$(".member_name").each(function(){
			$(this).autocomplete('/members.js');
		})
	}
	
	$('.add_field').click(function(){
		$(".member_name").each(function(){
			$(this).autocomplete('/members.js');
		})
	})
	
});

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
	return false;
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().parent().before(content.replace(regexp, new_id));
	return false;
}