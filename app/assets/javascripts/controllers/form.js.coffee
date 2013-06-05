#
#  Please include protos.js before using this
#
$.Controller "FormController",
  init: ->
    console.log "Form controller enabled"
    @setup_validation()
    @setup_submit()

  setup_validation: ->
    @validator = @element.validate(
      ignore: ""
      highlight: (el, e_cls) ->
        $(el).addClass e_cls

      unhighlight: (el, e_cls) ->
        $(el).removeClass e_cls

      errorPlacement: (err, el) ->

      onkeyup: false
      onfocusout: false
      focusCleanup: true
      focusInvalid: false
      minlength: 3
    )

  setup_submit: ->
    console.log "You can redifine this method and submit method"

  ".submit -> click": (ev) ->
    ev.preventDefault()
    @submit_element()  if @element.valid()

  ".reset -> click": (ev) ->
    ev.preventDefault()
    @element.find("input, textarea").val ""

  show_errors: (text) ->
    text = text or "error"
    console.log text

  submit_element: ->
    @submit_from()

  submit_from: ->
    self_form = this
    $.ajax
      url: @element.attr("action")
      data: @element.serialize()
      type: "post"
      dataType: "json"
      success: (resp) ->
        (if resp.success then self_form.success_call_back(resp) else self_form.failure_call_back(resp))


  
  # ajax callbacs you must redifine in your controller
  success_call_back: ->
    console.error "Redefine this method"

  failure_call_back: ->
    console.error "Redefine this method"

  
  # Reg exp classes for inputs
  special_test: (ev, test) ->
    el = $(ev.target)
    el.val el.val().replace(test, "")

  ".only_chars -> keyup": (ev) ->
    el = $(ev.target)
    el.val el.val().replace(/[^а-яА-ЯA-zA-Z]/, "")

  ".only_chars_and_numbers -> keyup": (ev) ->
    el = $(ev.target)
    el.val el.val().replace(/[^а-яА-ЯA-zA-Z0-9]/, "")

  ".only_cyrylic -> keyup": (ev) ->
    el = $(ev.target)
    el.val el.val().replace(/[^а-яА-Я]/, "")

  ".only_latin -> keyup": (ev) ->
    el = $(ev.target)
    el.val el.val().replace(/[^a-zA-Z]/, "")

  ".only_numbers -> keyup": (ev) ->
    el = $(ev.target)
    el.val el.val().replace(/[^0-9]/, "")

  ".only_latin_with_spaces -> keyup": (ev) ->
    el = $(ev.target)
    el.val el.val().replace(/[^a-zA-Z\s]/, "")

  ".only_cyrylic_with_spaces -> keyup": (ev) ->
    el = $(ev.target)
    el.val el.val().replace(/[^а-яА-Я\s]/, "")

  ".without_spaces -> keyup": (ev) ->
    el = $(ev.target)
    el.val el.val().replace(/\s/, "")

  ".latin_with_numbers -> keyup": (ev) ->
    el = $(ev.target)
    el.val el.val().replace(/[^0-9a-zA-Z]/, "")

  ".latin_with_numbers_and_spaces -> keyup": (ev) ->
    el = $(ev.target)
    el.val el.val().replace(/[^0-9a-zA-Z\s]/, "")

  ".cyrylic_with_numbers -> keyup": (ev) ->
    el = $(ev.target)
    el.val el.val().replace(/[^0-9а-яА-Я]/, "")

  ".cyrylic_with_numbers_and_spaces -> keyup": (ev) ->
    el = $(ev.target)
    el.val el.val().replace(/[^0-9а-яА-я\s]/, "")

  ".translit_to_latin -> keyup": (ev) ->
    el = $(ev.target)
    el.val el.val().translit()

  ".translit_to_cyrulic -> keyup": (ev) ->
    el = $(ev.target)
    el.val el.val().de_translit()

  ".max_chars -> keyup": (ev) ->
    el = $(ev.target)
    
    # TODO
    el.val().length