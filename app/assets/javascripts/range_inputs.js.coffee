$(document).ready () ->
  $('.ranged').each (i, elem) ->
    selem = $ elem
    pelem = do selem.parent
    selem.css 'width', '75px'
  return
