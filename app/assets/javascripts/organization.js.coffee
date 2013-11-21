$(document).ready () ->
  $('.delete.action').on 'click', (e) ->
    alert_off = true
    alert_what = 'Nothing. Some bug here.'
    $('[name*=nothing]:checked').each (i, e) ->
      $.ajax {
        url: "/votings/#{$(e).data('target')}"
        type: 'DELETE'
        success: (b) ->
          parents = $(e).parents('tr')
          if b.notice
            if alert_off
              $(document).trigger 'custom:alert', b.notice
              alert_off = false
          else
            do parents.slideUp().remove
          return
        error: (e) ->
          console.log(e)
          return
      }
      return
    return

  return
