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
  $('#documents_wrapper').append html
  $('.del').last().click delete_document

  last_document_handler = $('#documents_wrapper').find('.document_handler').last()

  do thus.hide
  thus.after("<input type='file' name='#{this.name}'>")
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
  $('.row.documents .elem input[type*="file"]').change upload_document
  $('.row.documents .elem .del').click delete_document
  $('#organization_logo').change (e) ->
    img = loadImage(
      e.target.files[0],
      (data) ->
        $('.third .brand').find('img').
          attr('src', data.attr('src'))
        return
      ,
      {
        maxWidth: 165
        maxHeight: 165
        contain: true
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

      if fullwidth.length == 0
        bodyheader.append '<div class="fullwidth" style="display: none"><div class="loading_icon"></div></div>'
        fullwidth = bodyheader.find('.fullwidth')

        $.ajax {
          url: "/#{thus.data('target')}/form"
          type: 'get'
          success: (b) ->
            fullwidth.html b
            do bind_settings
            return
          error: (e) ->
            console.log(e)
            return
        }

      fullwidth.slideDown 'normal'
    else if thus.hasClass('less')
      thus.find('a').html '&#xf078;'
      thus.removeClass('less').addClass('more')

      fullwidth.slideUp 'normal'

    return

  return

return
