//= require active_admin/base
//= require global/spectrum
//= require timer
//= require highcharts
//= require chartkick
//= require admin/social_post
//= require i18n/translations

Highcharts.setOptions({
  lang: {
    months: I18n.translations.ru.date.month_names,
    shortMonths: I18n.translations.ru.date.abbr_month_names,
    weekdays: I18n.translations.ru.date.abbr_day_names,
  },
  global: {
    timezoneOffset: - 7 * 60
  },
  xAxis: {
    type: 'datetime',

    labels: {
      format: '{value:%e %b %H}'
    }
  },
  tooltip: {
    dateTimeLabelFormats: {
      millisecond: '%A, %b %e, %H:%M:%S.%L',
      second: '%A, %b %e, %H:%M:%S',
      minute: '%A, %b %e, %H:%M',
      hour: '%A, %b %e, %H:%M',
      day: '%e %b %H:%M', //'%A, %b %e, %Y',
      week: 'Week from %A, %b %e, %Y',
      month: '%B %Y',
      year: '%Y'
    }
  }
});

$(function(){
  $('.js_timer').each(function(){
    new Timer( $(this) );
  })
})
