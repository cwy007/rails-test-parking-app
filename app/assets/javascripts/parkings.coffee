# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# flash message fade out UI
$ ->
   flashCallback = ->
     $(".alert").fadeOut()
   setTimeout flashCallback, 6000
