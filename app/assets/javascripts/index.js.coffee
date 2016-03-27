$(document).on 'ajax:success', (status,data,xhr)->
  $("##{ data.annotation }-#{ data.id }").html(data.link)
