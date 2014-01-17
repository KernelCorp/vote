do $('.regular').slice(0, 5).show

$('#show_more').on 'click', () ->
  do $('.regular').show
  do $(this).remove
  return
