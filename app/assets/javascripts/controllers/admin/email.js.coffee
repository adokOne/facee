$.Controller "AdminEmailController",
  init: ->
    locale = @element.data("locale")
    $("#email_template_html").wysihtml5
      locale: locale
    @editor = $('textarea').data("wysihtml5").editor.composer;
  ".ui-group a -> click": (ev) ->
    ev.preventDefault()
    v = $(ev.target).attr("href").replace("#","")
    value = @editor.getValue() + " %" + v + "% "
    @editor.setValue(value)
