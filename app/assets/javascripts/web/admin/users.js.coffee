$(document).ready ->
  initRegionsSelect()
  $(".role_select").on "change", ->
    setRegionsSelect(@value)

initRegionsSelect = ->
  value = $(".role_select").val()
  setRegionsSelect(value)

setRegionsSelect = (value) ->
  if value == 'admin'
    $(".regions_select").prop "disabled", true
  else
    $(".regions_select").prop "disabled", false
