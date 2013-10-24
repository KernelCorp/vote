$(document).ready () ->
  $('.ranged').each (i, elem) ->
    selem = $ elem
    pelem = do selem.parent
    selem.css 'width', '75px'
    selem.attr 'name', null
    pelem.append "<p class='tgrey'>#{selem.data('currency')}</div>"
    pelem.append '<div class="slider"></div>'
    pelem.append "<input class='blocker' id='blocker_#{selem.data('type')}' type='checkbox'>"
    pelem.append "<label class='blocker_label' for='blocker_#{selem.data('type')}'>#{selem.data('fix')}</label>"

    slider = selem.siblings('.slider')
    slider.slider({
      range: "min"
      min: selem.data('min')
      max: selem.data('max')
      step: selem.data('step')
      value: 20
      slide: (e, ui) ->
        selem.val ui.value
    })
    selem.val slider.slider 'value'

    selem.data('target') and $("[name='#{selem.data('target')}']").on 'keyup', (e) ->
      selem.val this.value
      return

    cbox = selem.siblings('input.blocker')
    cbox.on 'change', (e) ->
      state = if this.checked then 'disable' else 'enable'
      slider.slider state
      return

    return

  $('.ranged[target]').on 'change', (e) ->
    thus = $ this
    $("[name='#{thus.data('target')}']").val(do thus.val)
    thus.siblings('.slider').slider 'value', do thus.val

  return
