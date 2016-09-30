#= require active_admin/base

$ ->
  $('.col-user a').each (i, value) ->
    $link = $(value)
    text = $link.text()
    if text.length > 10
      $link.text text.substring(0, 7) + '...'
