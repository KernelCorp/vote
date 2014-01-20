pid = $('#what_show').data 'pid'
population = $('#what_show').data 'population'
show_more = $ '.show_more'

show_more_on_page = (first, flimits, second, slimits) ->
  sm1 = do show_more.clone
  sm1.html().replace 'x', flimits.left
  sm1.html().replace 'y', flimits.right
  do sm1.show
  $('.regular').eq(first).after sm1

  if second
    sm2 = do show_more.clone
    sm2.html().replace 'x', slimits.left
    sm2.html().replace 'y', slimits.right
    do sm2.show
    $('.regular').eq(second).after sm2

  return

if pid - 2 <= 5
  do $('.regular').slice(0, pid + 2).show

  show_more_on_page pid + 1, { left: pid + 2, right: population }
else
  do $('.regular').slice(0, 5).show
  do $('.regular').slice(pid - 2, pid + 2).show

  show_more_on_page 4, { left: 5, right: pid - 3 }, pid + 1, { left: pid + 2, right: population }

$('.show_more').on 'click', () ->
  limits = $(this).html().match(/\d+/)
  do $('.regular').slice(limits[0], limits[1]).show
  do $(this).remove
  return
