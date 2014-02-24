//= require active_admin/base
//= require global/spectrum
//= require timer

$(function(){
  $('.js_timer').each(function(){
    new Timer( $(this) );
  })
})
