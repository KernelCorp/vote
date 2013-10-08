# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@phone_widget = (selector) ->
  url = 'http://localhost:3000/'
  success = (r) ->
    $(selector).html "<iframe src='http://localhost:3000/' height='300' width='800'></iframe>"
    #$(selector + " iframe").html r
  error = (e) ->
    console.log e
  $.ajax {
    url: url
    method: 'GET'
    success: success
    error: error
  }
