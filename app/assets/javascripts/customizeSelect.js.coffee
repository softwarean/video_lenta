$(document).ready ->
  $(".fmap-filter-select, .fareast-form select").customSelect()
  return

window.onload = ->
  setRightCustomSelectWidth()
$(window).resize ->
  setRightCustomSelectWidth()

setRightCustomSelectWidth = ->
  parentWidth = parseInt($(".customSelect:eq(0)").outerWidth(), 10)
  $(".fmap-navbar .customSelectInner, .fmap-navbar-control select").css
    display: "block"
    width: parentWidth + "px"
