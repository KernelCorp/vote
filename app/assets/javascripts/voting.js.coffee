# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready () ->
  arrow_position = [ '55px', '85px', '', '', '', '', '', '', '', '' ]

  $('[data-rate]').each (i, e) ->
    rate = $(e).data 'rate'
    if (parseInt(rate) <= 1) or (parseInt(rate) >= 4)
      return
    clazz = 'place'
    clazz += " #{$(e).data 'color'}"
    clazz += (if i % 2 == 1 then ' top' else ' bottom')
    $(e).append "<div class='#{clazz}'>#{rate}<div class='arrow'></div></div>"
    $(e).addClass 'tred'
    return

  $('#your_phone .number').on 'click', (e) ->
    id = $('#your_phone').data 'voting-id'
    number = do $(this).html
    position = $('#your_phone ul li.number').index this
    originalHtml = do $('#number_info').html
    do $('#number_info').show
    $('#arrow_up').css({left: arrow_position[position]})
    $.ajax {
      url: "/voting/#{id}/info/#{number}/at/#{position}"
      type: "POST"
      success: (r) ->
        $('#number_info').html r
        $('#number_info').on 'keypress', (e) ->
          if e.key == '9'
            do $(this).hide
            $(this).html originalHtmt
          return
        return
      error: (e) ->
        console.log(e)
        return
    }

  return
