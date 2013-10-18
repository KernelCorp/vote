# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready () ->
  $('[data-rate]').each (i, e) ->
    rate = $(e).data('rate')
    if(parseInt(rate) <= 1 || parseInt(rate) >= 4)
      return
    clazz = 'place'
    clazz += " #{$(e).data('color')}"
    clazz += (if i % 2 == 1 then ' top' else ' bottom')
    clazz += (if i > 5 then ' right' else ' left')
    $(e).append("<div class='#{clazz}'>#{rate}</div>")
    return

  $('#your_phone .number').on 'click', (e) ->
    id = $('#your_phone').data('voting-id')
    number = $(this).html()
    position= $('#your_phone ul li').index(this)
    $('#number_info').show
    $('#number_info #arrow_up').css('left', )
    $.ajax {
      url: "/voting/#{id}/info/#{number}/at/#{position}"
      type: "POST"
      success: (r) ->
        $('#number_info').html(r)
        $('#number_info').on 'keypress', (e) ->
          if(e.key == '9')
            $(this).hide
          return
        $()
        return
      error: (e) ->
        console.log(e)
        return
    }
