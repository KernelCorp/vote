(function(){

  $(document).ready(function(){
    var alert_smoke = $('#app_alert_smoke');
    var alert = $('#app_alert_div');

    alert.find('#alert_button').on('mousedown', function(){
      alert_smoke.add(alert).fadeOut( 500 );
    });

    $(this).on('custom:alert', function(e, _alert, _path_to_go){
      alert.find('#alert_text').text( _alert );
      alert_smoke.add(alert).fadeIn( 500 );

      if( _path_to_go != undefined ) window.location.href = _path_to_go || window.location.href;
    });
  });
})();