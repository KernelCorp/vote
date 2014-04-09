//= require active_admin/base
//= require global/spectrum
//= require timer
//= require highcharts
//= require chartkick
//= require admin/zone_filter

Highcharts.setOptions({
  global: {
    timezoneOffset: - 7 * 60
  }
});

$(function(){
  $('.js_timer').each(function(){
    new Timer( $(this) );
  })
})
