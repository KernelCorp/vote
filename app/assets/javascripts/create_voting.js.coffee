$(document).ready () ->
  $('#organization').find('input[type*="file"][name*="voting"]').on 'change', (e) ->
    reader = false
    thus_name = $(this).attr 'id'
    selector = ".#{thus_name}"
    thus_img = $(this).parent().siblings('.loaded').children('img')
    width = if thus_name.indexOf('brand') >= 0 then 200 else 220
    height = if thus_name.indexOf('brand') >= 0 then 70 else 265
    clazz = if thus_name.indexOf('brand') >= 0 then 'widget_brand' else 'widget_image'
    if typeof FileReader != 'undefined'
      loadImage(
        e.target.files[0],
        (img) ->
          thus_img.attr 'src', do img.toDataURL
          img.class_name = clazz
          $(selector).children('img, canvas').first().replaceWith img
          return
        {
          maxWidth: width
          maxHeight: height
          minWidth: width
          minHeight: height
          crop: true
        }
      )
    else
      kitty = if thus_name.indexOf('brand') >= 0 then 'http://lorempixel.com/200/70/cats' else 'http://lorempixel.com/220/265/cats'
      thus_img.attr('src', kitty)
      $(selector).find('img').attr('src', kitty)
    return

  $('#organization').find('input[id*="voting_name"]').on 'change', () ->
    $(".#{$(this).attr('id')}").html($(this).val())
    return

  $('.date').datepicker({ dateFormat: 'yy-mm-dd' })

  return
