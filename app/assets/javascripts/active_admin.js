//= require active_admin/base
//= require global/spectrum
//= require timer
//= require highcharts
//= require chartkick

$(function(){
  $('.js_timer').each(function(){
    new Timer( $(this) );
  })
})
