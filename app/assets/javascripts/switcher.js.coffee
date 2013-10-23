$(document).ready () ->
  $('.switcher .elem').on 'click', (e) ->
    $(this).siblings('.active').removeClass('active')
    $(this).addClass('active')
    return

  return
