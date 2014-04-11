$ ()->
  
  container = $ '#voter_filters'

  return if container.length == 0

  
  selects = container.children 'select'
  
  rows = $ '#voters_index tbody tr'

  counter = $ '#filtered_rows' 

  filters = {}


  update_counter = ()->
    counter.text 'Строк - ' + rows.filter(':visible').length

  
  filters_apply = ()->
    rows.show()

    rows.filter ()->
      for filter, value of filters
        if $(this).find("[data-#{filter}=\"#{value}\"]").length == 0
          return true
      return false
    .hide()

    update_counter()


  selects.on 'change', ()->
    select = $ this

    v = select.val()
    f = select.data 'filter'

    if v == '-1'
      delete filters[f]
    else
      filters[f] = v

    filters_apply()


  update_counter()
