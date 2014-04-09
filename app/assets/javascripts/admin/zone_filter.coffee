$ ()->
  
  select = $ '#zone_filter'

  return if select.length == 0
  
  rows = $ '#voters_index tbody tr'

  select.on 'change', ()->
    v = select.val()

    rows.show()

    if v != '-1'
      rows.filter ()-> 
        !$(this).find('[data-value=\"'+v+'\"]').length
      .hide()
