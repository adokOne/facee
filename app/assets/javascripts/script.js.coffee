$ ->
  $('*[data-auto-controller]').each ->
    if(plg = $(this)['attach'+$(this).data('auto-controller')])
      plg.call($(this))