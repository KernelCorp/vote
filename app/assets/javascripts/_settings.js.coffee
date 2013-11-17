number = 0

delete_document = (e) ->
  thus = $(this)
  target = thus.parent().data('target')
  if $(this).parent().data('id')
    $.ajax {
      url: "/organization/document/#{thus.parent().data('id')}/destroy"
      type: 'DELETE'
      success: (b) ->
        thus.parent().remove()
        return
      error: (e) ->
        console.log(e)
        return
    }
  else
    $("##{target}").remove()
    $(this).parent().remove()
  return

upload_document = (e) ->
  thus = $(this)

  if this.value.length == 0
    return

  html = "<div class='document_handler lightgreenoblue' data-fallback='document #{number}'><p></p><div class='fa del'>&#xf00d;</div></div>"
  $('#settings_organization_documents_wrapper').append html
  $('.del').last().click delete_document

  last_document_handler = $('#settings_organization_documents_wrapper').find('.document_handler').last()

  do thus.hide
  thus.before "<input type='file' name='#{this.name}'>"
  thus.siblings('input[type*=file]').change upload_document

  if typeof FileReader == 'undefined'
    last_document_handler.find('p').html last_document_handler.data('fallback')
  else
    reader = new FileReader()
    reader.onload = (e) ->
      last_document_handler.find('p').html thus.val().match(/[^\/\\]+$/)
      return
    for file in this.files
      reader.readAsDataURL(file)

  this.id = "document_number_#{number++}"
  last_document_handler.data 'target', this.id

  return

bind_settings = () ->
  $('.row#settings_organization_documents input[type*="file"]').change upload_document
  $('.row#settings_organization_documents .del').click delete_document
  $('#organization_avatar').change (e) ->
    img = loadImage(
      e.target.files[0],
      (img) ->
        console.log img
        $('.third .brand').find('img, canvas').replaceWith(img)
        return
      , {
        maxWidth: 165
        maxHeight: 165
        minWidth: 165
        minHeight: 165
        crop: true
      }
    )
    if !img
      $('.third .brand').find('img').
        attr('src', 'http://lorempixel.com/165/165/cats')
    return
  return


$(document).ready () ->
  do bind_settings

  $('#settings').find('.clickable').click (e) ->
    $('#settings').find('.expander').trigger 'click'
    return

  $('#settings').find('.expander').click (e) ->
    thus = $(this)
    bodyheader = $('#bodyheader')
    fullwidth = bodyheader.find('.fullwidth')
    settings = $('#settings')

    if thus.hasClass('more')
      thus.find('a').html '&#xf077;'
      thus.removeClass('more').addClass('less')
      thus.siblings('a').html thus.data('less')

      fullwidth.slideDown 'normal'
    else if thus.hasClass('less')
      thus.find('a').html '&#xf078;'
      thus.removeClass('less').addClass('more')
      thus.siblings('a').html thus.data('expand')

      fullwidth.slideUp 'normal'

    return

  $('#participant_balance_fillup').on 'click', (e) ->
    do e.stopPropagation
    do $('.floating_block').show
    do $('#app_fog').show
    $.ajax {
      url: '/payments/new'
      success: (b) ->
        $('.floating_block').html b
        return
      error: (e) ->
        console.log e
        return
    }
    false

  return

return
