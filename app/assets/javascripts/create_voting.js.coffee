$(document).ready () ->
  $('#organization').find('input[type*="file"]').on 'change', (e) ->
    reader = false
    thus_name = $(this).attr 'id'
    thus_imgs = [ $(this).parent().siblings('.loaded').children('img') ]
    thus_imgs.push $('#organization').find(".#{thus_name}")
    if typeof FileReader != 'undefined'
      reader = new FileReader()
      reader.onload = (event) ->
        thus_imgs.forEach (i, index) -> i.attr('src', event.target.result)
        return
      reader.readAsDataURL(e.target.files[0])
    else
      kitty = thus_name.indexOf('brand') >= 0 ? 'http://lorempixel.com/200/70/cats' : 'http://lorempixel.com/220/265/cats'
      thus_imgs.forEach (i, index) ->  i.attr('src', kitty); return
    return

  $('#organization').find('input[id*="voting_name"]').on 'change', () ->
    $(".#{$(this).attr('id')}").html($(this).val())
    return

  $('.date').datepicker({ dateFormat: 'yy-mm-dd' })

  return
