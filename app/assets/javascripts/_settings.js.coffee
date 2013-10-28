number = 0

delete_document = (e) ->
  target = $(this).parent().data('target')
  $("##{target}").remove()
  $(this).parent().remove()
  return

upload_document = (e) ->
  thus = $(this)

  if this.value.length == 0
    return

  html = '<div class="document_handler lightgreenoblue"><p></p><div class="del">&#10005;</div></div>'
  $('#documents_wrapper').append html
  $('.del').last().click delete_document

  thus.css { dispaly: 'none' }
  thus.after("<input type='file' name='#{this.name}'>")
  thus.siblings('input[type*=file]').change upload_document

  if typeof FileReader == 'undefined'
    $('#documents_wrapper').find('.document_handler p').html thus.data('fallback')
  else
    reader = new FileReader()
    reader.onload = (e) ->
      $('.document_handler').last().find('p').html thus[0].files[0].name
      return
    for file in this.files
      reader.readAsDataURL(file)

  this.id = "document_number_#{number++}"
  $('.document_handler').last().data('target', this.id)

  return

$(document).ready () ->
  $('#settings').find('.clickable').click (e) ->
    $('#settings').find('.expander').trigger 'click'
    return

  $('#settings').find('.expander').click (e) ->
    thus = $(this)
    bodyheader = $('#bodyheader')
    fullwidth = bodyheader.find('.fullwidth')
    settings = $('#settings')

    if thus.hasClass('more')
      thus.find('a').html '&#8963;'
      thus.removeClass('more').addClass('less')

      if fullwidth.length == 0
        bodyheader.append '<div class="fullwidth" style="display: none"><div class="loading_icon"></div></div>'
        fullwidth = bodyheader.find('.fullwidth')

        $.ajax {
          url: '/organization/form'
          type: 'get'
          success: (b) ->
            fullwidth.html b
            $('.row.documents .elem input[type*="file"]').change upload_document
            return
          error: (e) ->
            console.log(e)
            return
        }

      fullwidth.slideDown 'normal'
    else if thus.hasClass('less')
      thus.find('a').html '&#8964;'
      thus.removeClass('less').addClass('more')

      fullwidth.slideUp 'normal'

    return

  return

return
