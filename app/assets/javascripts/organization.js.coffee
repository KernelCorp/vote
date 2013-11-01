$(document).ready () ->
  $('.delete.action').on 'click', (e) ->
    $('[name*=nothing]:checked').each (i, e) ->
      $.ajax {
        url: "/organization/voting/#{$(e).data('target')}/destroy"
        type: 'DELETE'
        success: (b) ->
          do $(e).parents('tr').remove
          return
        error: (e) ->
          console.log(e)
          return
      }
      return
    return

  return
