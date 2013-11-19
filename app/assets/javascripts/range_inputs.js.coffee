$(document).ready () ->
  # init
  $('.ranged').each (i, elem) ->
    selem = $ elem
    pelem = do selem.parent
    selem.css 'width', '85px'
    pelem.append "<p class='tgrey'>#{selem.data('currency')}</div>"
    pelem.append '<div class="slider"></div>'
    pelem.append "<input class='blocker radiocheck' id='blocker_#{selem.data('type')}' type='checkbox'>"
    pelem.append "<label class='blocker_label fixed_length tgrey' for='blocker_#{selem.data('type')}'>#{selem.data('fix')}</label>"

    # init slider
    slider = selem.siblings '.slider'
    slider.slider {
      range: "min"
      min: selem.data('min')
      max: selem.data('max')
      step: selem.data('step')
      value: 1
      slide: (e, ui) ->
        selem.val ui.value
        selem.trigger 'change'
        selem.data('target') and $("##{selem.data('target')}").val ui.value
    }
    selem.val slider.slider('value')

    # Connection between inputs
    selem.data('target') and $("##{selem.data('target')}").on 'change', (e) ->
      if parseInt(this.value) > 0 then selem.val this.value else selem.val 1
      selem.trigger 'change'
      return

    # Init blockers
    cbox = selem.siblings('input.blocker')
    cbox.on 'change', (e) ->
      thus = this
      $('input.blocker').each (i, elem) ->
        if thus == elem
          elem.checked = true
          return
        elem.checked = false
        brother = $(elem).siblings('.ranged')
        brother.siblings('.slider').slider 'enable'
        brother.attr 'disabled', null
        brother.data('target') and $("##{brother.data('target')}").attr 'disabled', null
        return
      [state, disabled] = if this.checked then ['disable', 'disabled'] else ['enable', null]
      slider.slider state
      selem.attr 'disabled', disabled
      selem.data('target') and $("##{selem.data('target')}").attr 'disabled', disabled
      return

    return

  # Binding ranges for sliders
  $('#voting_min_count_users').on 'change', (e) ->
    value = parseInt this.value
    if value <= 0
      value = 1
    delta = 5000
    vmus = $('#voting_max_users_count')
    vmus.val value
    vmus.trigger 'change'
    vmus.siblings('.slider').slider 'option', { min: value, max: value + delta, value: value }
    return

  $('#voting_min_sum').on 'change', (e) ->
    vb = $('#voting_budget')
    vms = $('#voting_min_sum')
    value = parseInt this.value
    if value <= 0
      value = 1
    options = {
      min: value
      value: value
    }
    if value > vb.siblings('.slider').slider 'option', 'max'
      value = vb.val() - 50
      delta = vb.siblings('.slider').slider('option', 'max') - vb.siblings('.slider').slider('option', 'min')
      options = {
        min: value
        max: value + delta
        value: value
      }
    vb.val value
    vb.trigger 'change'
    vb.siblings('.slider').slider 'option', options
    return

  $('#voting_financial_threshold').on 'change', (e) ->
    vb = $('#voting_budget')
    vms = $('#voting_min_sum')
    value = parseInt this.value
    if value <= 0
      value = 50000
    options = {
      max: value
      value: value
    }
    if value < vb.siblings('.slider').slider 'option', 'min'
      value = parseInt(do vms.val) + 50
      delta = vb.siblings('.slider').slider('option', 'max') - vb.siblings('.slider').slider('option', 'min')
      options = {
        min: if value - delta > 0 then value - delta else 1,
        max: value,
        value: value
      }
    vb.val value
    vb.trigger 'change'
    vb.siblings('.slider').slider 'option', options
    return

  # Simple bind
  $('.ranged:not([data-target])').on 'change', (e) ->
    thus = $ this
    thus.siblings('.slider').slider 'value', do thus.val
    return

  # Bind 2 inputs and slider
  $('.ranged[data-target]').on 'change', (e) ->
    thus = $ this
    $("##{thus.data('target')}").val thus.val()
    thus.siblings('.slider').slider 'value', do thus.val
    return

  # Calculation
  $('.ranged').on 'change', (e) ->
    active = $('.ranged').not('[disabled]').not(this)
    blocked = $('.ranged').filter('[disabled]')
    value = 1
    if blocked.filter('[id*="budget"]').length != 0
      value = Math.ceil(parseInt(blocked.val()) / parseInt(this.value))
    else if active.filter('[id*="budget"]').length != 0
      value = parseInt(blocked.val()) * parseInt(this.value)
    else
      value = Math.ceil(parseInt(this.value) / parseInt(blocked.val()))
    min = active.siblings('.slider').slider 'option', 'min'
    max = active.siblings('.slider').slider 'option', 'max'
    if value >= max
      value = max
    if value <= min
      value = min
    active.val value
    active.trigger 'change'
    active.siblings('.slider').slider 'value', value
    return

  $('#blocker_cost').attr 'checked', 'checked'
  $('#blocker_cost').trigger 'change'

  return
