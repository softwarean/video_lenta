window.onload = ->
  setMapFilterHeight()
$(window).resize ->
  setMapFilterHeight()

setMapFilterHeight = ->
  filterHeight = parseInt($('.fmap-navbar').outerHeight(), 10)
  $('.nav-tabs').css
    marginBottom: filterHeight + "px"
