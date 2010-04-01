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
	
	$(".tabs li a").click(function (){
	  $.get($(this).attr("href"), null, null, 'script');
	  $(".propuesta").hide();
	  $("#spinner").show();
	  return false;
	})
	
	if ($("body").hasClass("dashboard")) {
	  $("a#search_link").fancybox();
	  $("a.invite_link").fancybox();
	  $("a.signup_link").fancybox({'autoDimensions':false,'width':460,'height':530});
	}
	
	if (($("body").hasClass("dashboard") && $("body").is(":not(.logged)")) || $("body").hasClass("user")){
	  $("a.what").tinyTips('light', "<div class='left'><h2 class='lightbox'>Credencial de Elector</h2><p>Te pedimos el número de la <strong>sección</strong> para identificar tu distrito, este número viene localizado en la parte inferior de la Credencial de Elector.</p></div><img src='/images/credencial.png'/>");
	}
	
	// ------------- Login --------------
	$("a#signin_link").click(function(e) {
       e.preventDefault();
       $("#login").toggle();
       $("a#signin_link").toggleClass("main_b");
   });

   $("#login").mouseup(function() {
       return false
   });
   $(document).mouseup(function(e) {
       if($(e.target).parent("a#signin_link").length==0) {
           $("a#signin_link").removeClass("main_b");
           $("#login").hide();
       }
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
	
	// ------------- Editar Votos --------------
	
	$("a.multiple_vote_select").click(function(){
	  if ($(this).attr("data-vote") == "for") {
	    $(this).next().next().find("input.for").attr("checked", "checked")
	  } else if ($(this).attr("data-vote") == "against"){
	    $(this).next().find("input.against").attr("checked", "checked")
	  }
	  return false;
	  
	})
	
	// ------------- Usuario --------------------
	
	// Cambiar foto del perfil
	$("a#change_avatar").click(function(){
	  $("#avatar").hide();
	  $("#avatar_field").show();
  })
  
  $("a#cancel_change_avatar").click(function(){
    $("#avatar_field").hide();
    $("#avatar").show();
  })
  
  // Cambiar password 
  $("a#change_password").click(function(){
    $(".password_fields").show().find("input").val("");
    $(this).hide()
    $("a#not_change_password").show();
    return false;
  })
  
  $("a#not_change_password").click(function(){
    $(".password_fields").hide().find("input").val("");
    $(this).hide()
    $("a#change_password").show();
    return false;
  })
	
	// Autocomplete en la forma de registro y al editar la info del usuario
	if ($("body").hasClass("user")) {
		$(".city_name").each(function(){
			$(this).autocomplete('/cities.js');
		})
	}
	
	// Agregar temás de interés a usuarios/noticias/propuestas
	// Si el usuario selecciona el tema de interés, se va a habilitar/deshabilitar el hidden field
	$("a.tag").click(function(){
	  if ($(this).hasClass("selected_tag")) {
	    $(this).removeClass("selected_tag").next().attr("disabled", "disabled");
	  } else {
	    $(this).addClass("selected_tag").next().attr("disabled", "");
	  }
	  return false;
	})
	
	// Warning si se intenta salir y no ha guardado los cambios
	if ($("body").hasClass("edit_citizen")) {
	  $("form input, form select").change(function(){
	    alert("change input or select");
	    $("body").addClass("changed");
	  })
	  
	  $("form a.tag").click(function(){
	    $("body").addClass("changed");
	  })
	  
	  $("#header a").click(function(){
	    if ($("body").hasClass("changed")){
	      if (confirm("No has guardado tus cambios, ¿Aun así quieres salir?")) {
  	      window.location = $(this).attr("href");
  	    } else {
  	      return false;
  	    }
	    }
	  })
	}
	
	// Votos de los ciudadanos
	$("a.vote").live('click', function(){
		$.post($(this).attr("href"), { vote: $(this).attr('data-vote'), voteable: $(this).attr('data-voteable') }, null, "script");
		return false;
	});
	
	// Load districts into the select field when a state is selected
	$("select#member_state_id").change(function(){
	  $.get('/districts', {state_id: $(this).val()}, function(data){
	   $("select#member_district_id").html(data); 
	  })
	})
	
	// Show district select if member is a "mayoria relativa"
	$("input#member_election_mayoría_relativa").click(function(){
	  $("select#member_district_id").parent().show();
	})
	
	// Hide district select if member is a "plurinominal"
	$("input#member_election_representación_proporcional").click(function(){
	  $("select#member_district_id").parent().hide();
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