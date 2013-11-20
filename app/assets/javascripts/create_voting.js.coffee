$(document).ready () ->
  $('#organization').find('input[type*="file"][name*="voting"]').on 'change', (e) ->
    reader = false
    thus_name = $(this).attr 'id'
    selector = "#changed_#{thus_name}"
    thus_img = $(this).parents('.loadable').siblings('.loaded').children 'img'

    if thus_name != 'voting_custom_background'
      width = if thus_name.indexOf('brand') >= 0 then 200 else 220
      height = if thus_name.indexOf('brand') >= 0 then 70 else 165
      clazz = if thus_name.indexOf('brand') >= 0 then 'widget_brand' else 'widget_image'

    if typeof FileReader != 'undefined'
      loadImage(
        e.target.files[0],
        (img) ->
          thus_img.attr 'src', do img.toDataURL
          if thus_name == 'voting_custom_background'
            $('.standard_background').get(0).style.backgroundImage = "url('#{img.toDataURL()}')"
          else
            img.className = clazz
            $(selector).children('img, canvas').first().replaceWith img
          return
        , {
          maxWidth: width
          maxHeight: height
          minWidth: width
          minHeight: height
          crop: true
        }
      )
    else
      kitty = if thus_name.indexOf('brand') >= 0 then 'http://lorempixel.com/200/70/cats' else 'http://lorempixel.com/220/165/cats'
      thus_img.attr 'src', kitty
      $(selector).find('img').attr 'src', kitty
    return


  $('#organization').find('input[id*="voting_name"]').on 'change', () ->
    $(".#{$(this).attr('id')}").html($(this).val())
    return

  $('.create_voting .date').datepicker {
    dateFormat: 'dd/mm/yy'
    nextText: ''
    prevText: ''
    firstDay: 1
    dayNames: ['Воскресенье', 'Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота']
    dayNamesMin: ['Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб']
    monthNames: ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь']
  }

  return
