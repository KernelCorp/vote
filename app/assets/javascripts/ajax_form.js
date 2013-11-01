$(document).on('focusin', function(e){
  if( $(e.target).hasClass('form_error_input') )
    $(e.target).removeClass('form_error_input');
});

$(document).on( "ajax:beforeSend", function(e){
  $(e.target).find('input[type="submit"]').prop( "disabled", true );
});

$(document).on( "ajax:complete", function(e){
  $(e.target).find('input[type="submit"]').prop( "disabled", false );
});

$(document).on( "ajax:error", function(){
  console.log( 'ajax error' );
});

$(document).on( "ajax:success", function(e, data, status, xhr){
  console.log( JSON.stringify( data ) );

  if( data.success ){
    window.location.href = data.path_to_go;
  } else {
    var form = $(e.target);

    if( data.errors === 'login' ){
      form.find(".form_error_enter").fadeIn(1000);

    } else {
      var resource = data.resource;
      var error;

      form.find(".form_error_input").removeClass(".form_error_input");
      form.find(".form_error_message").remove();

      for( var attr in data.errors ){
        form
        .find("#"+resource+"_"+attr)
        .addClass("form_error_input")
        .after(
          $('<div class="form_error_message">'+data.errors[attr][0]+'</div>')
          .fadeIn(1000)
        );
      }
    }
  }
});