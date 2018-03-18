$(document).on 'ajax:success', 'span[annotation-listener]', (status,data,xhr)->
  $("##{ data.annotation }-#{ data.id }").html(data.link)

$(document).on 'ajax:success', 'span[panel-listener]', (status,data,xhr)->
  $("#panel-#{ data.id }").html(data.panel_content)

Mousetrap.bind 'alt+t', (e)->
  document.getElementById("movie_title_pattern").focus()
