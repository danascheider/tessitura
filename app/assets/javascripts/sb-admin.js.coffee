$ ->
  $('#side-menu').metisMenu()

# Loads the correct sidebar on window load,
# collapses the sidebar on window resize
$ ->
  $(window).bind "load resize", ->
    width = if @.window.innerWidth > 0 then @.window.innerWidth; else @.screen.width
    if width < 768
      $('div.sidebar-collapse').addClass 'collapse'
    else
      $('div.sidebar-collapse').removeClass 'collapse'