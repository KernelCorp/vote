function ajok_mask( inputs, mask, regexp, placeholder ){
  inputs.each(function(){
    var input = $(this);
    var hidden = input.prev();

    input.attr('placeholder', placeholder);
    input.mask( mask, 
      { 
        completed: function(){ 
          $(this).trigger('change'); 
        } 
      } 
    )
    .on('change', checkMask);

    input.closest('form').on('ajax:before', checkMask);

    function checkMask(){
      var matches = input.val().match( regexp ) || [];
      var result = '';
      if( matches.length ){
        if( matches.length == 1 ){
          result = matches[0];
        } else {
          for( var i=1; i<matches.length; i++ ){
            result += matches[i];
          }
        }
      }
      hidden.val( result );
    }
  });
}