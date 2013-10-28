$(document).ready () ->
  $('#settings').find('.clickable').click (e) ->
    $('#settings').find('.expander').trigger 'click'
    return

  $('#settings').find('.expander').click (e) ->
    thus = $(this)
    bodyheader = $('#bodyheader')
    fullwidth = bodyheader.find('.fullwidth')
    settings = $('#settings')

    if thus.hasClass('more')
      thus.find('a').html '&#8963;'
      thus.removeClass('more').addClass('less')

      if fullwidth.length == 0
        bodyheader.append '<div class="fullwidth" style="display: none"><div class="loading_icon"></div></div>'
        fullwidth = bodyheader.find('.fullwidth')

        $.ajax {
          url: '/organization/form'
          type: 'get'
          success: (b) ->
            fullwidth.html b
            return
          error: (e) ->
            console.log(e)
            return
        }

      fullwidth.slideDown 'normal'
    else if thus.hasClass('less')
      thus.find('a').html '&#8964;'
      thus.removeClass('less').addClass('more')

      fullwidth.slideUp 'normal'

    return

  return

return
