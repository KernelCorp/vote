__debug = true

$(document).on('mousedown', function(e){
  if( $(e.target).hasClass('form_error_input') )
    $(e.target).removeClass('form_error_input');
});

$(document).on( "ajax:beforeSend", function(e, xhr, settings){
  var q = $(e.target);
  if( q.data('ask') ){
    xhr.abort();
    $.ajax( settings );
  } else {
    $(e.target).find('input[type="submit"]').prop( "disabled", true );
  }
});

$(document).on( "ajax:complete", function(e){
  $(e.target).find('input[type="submit"]').prop( "disabled", false );
});

$(document).on( "ajax:error", function(ev, s, er){
  console.log('ajax error: ');
  console.log(ev);
  console.log('ajax status: ');
  console.log(s);
  console.log('ajax error: ');
  console.log(er);
});

$(document).on( "ajax:success", function(e, data, status, xhr){
  __debug && console.log( JSON.stringify( data ) );

  var form = $(e.target)
  form.find(".form_error_input").removeClass("form_error_input");
  form.find(".form_error_message").remove();

  if( !data._success ){
    if( data._errors ) {
      var resource = data._resource;
      var error_input;
      var error_container;

      for( var attr in data._errors ){
        error_input = form.find("#"+resource+"_"+attr);

        if( error_input.hasClass('select_input') ){
          error_container = error_input.closest('.select');
          error_input = error_container.children('.select_current');
        } else {
          error_container = error_input;
        }

        error_input.addClass("form_error_input");
        error_container.after( $('<div class="form_error_message">'+data._errors[attr][0]+'</div>').show() );
      }
    }

    if( data._error ){
      form.find(".form_error_enter")
      .html(form.data(data._error))
      .fadeIn(1000);
    }
  }

  if( data._alert ){
    form.trigger( 'custom:alert', [ form.data(data._alert), data._path_to_go ] );
  }
  else if( data._path_to_go != undefined ){
    window.location.href = data._path_to_go || window.location.href;
  }
});
