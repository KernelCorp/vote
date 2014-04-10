$ ()->
  
  container = $ '#voter_filters'

  return if container.length == 0

  
  selects = container.children 'select'
  
  rows = $ '#voters_index tbody tr'

  counter = $ '#filtered_rows' 

  filters = {}

  
  filters_apply = ()->
    rows.show()

    rows.filter ()->
      for filter, value of filters
        if $(this).find("[data-#{filter}=\"#{value}\"]").length == 0
          return true
      return false
    .hide()

    counter.text 'Подходит под критерий - ' + rows.filter(':visible').length


  selects.on 'change', ()->
    select = $ this

    v = select.val()
    f = select.data 'filter'

    if v == '-1'
      delete filters[f]
    else
      filters[f] = v

    filters_apply()
