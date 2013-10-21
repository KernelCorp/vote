$(document).ready () ->
  arrow_position = [
    '55px',
    '82px',
    '109px',
    '161px',
    '187px',
    '214px',
    '264px',
    '291px',
    '343px',
    '371px'
  ]

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
    number = parseInt(do $(this).html)
    position = $('#your_phone ul li.number').index this
    originalHtml = do $('#number_info').html
    do $('#number_info').show
    $.ajax {
      url: "/votings/#{id}/info/#{number}/at/#{position}"
      type: "POST"
      success: (r) ->
        $('#number_info').html r
        $('#arrow_up').css({left: arrow_position[position]})
        $('#number_info').on 'keypress', (e) ->
          if e.key == '9'
            do $(this).hide
            $(this).html originalHtml
          return
        return
      error: (e) ->
        console.log(e)
        return
    }

    return

  return
