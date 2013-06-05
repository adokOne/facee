$.Controller "AdminSettingsController",
  init: ->
    locale = @element.data("locale")
    $("textarea").wysihtml5
      locale: locale
