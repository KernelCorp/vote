(function(){

  $(document).ready(function(){
    var alert_smoke = $('#app_alert_smoke');
    var alert = $('#app_alert_div');
    var both = alert.add(alert_smoke);

    alert.on('mouseup', '.button', function(){
      $(this).off('mousedown');
      both.stop(true).fadeOut( 500 );
    });

    $(this).on('custom:alert', function(e, _alert, _path_to_go){
      alert.find('#alert_text').text( _alert );
      both.stop(true).fadeIn( 500 );

      alert.find('.button').eq(1).hide();

      if( _path_to_go == undefined ) return;

      alert.find('.button').eq(0).on('mousedown', function(){
        window.location.href = _path_to_go || window.location.href;
      });
    });

    $(this).on('custom:ask', function(e, _alert, element, trigger){
      alert.find('#alert_text').text( _alert );
      both.stop(true).fadeIn( 500 );

      alert.find('.button').eq(1).show();

      alert.find('.button').eq(0).on('mousedown', function(){
        trigger = trigger || 'click';
        element.trigger( trigger );
      });
    });
  });

})();
