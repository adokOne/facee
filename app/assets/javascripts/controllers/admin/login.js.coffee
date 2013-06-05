#= require ../form
$.Controller "AdminLoginController", "FormController",
  init: ->
    console.log "2r32r32"
    @super_call("init")

  success_call_back: ->
    window.location.reload()

  failure_call_back: (resp) ->
    alert resp.error

$.Controller "LoginController", "FormController",
  init: ->
    @super_call("init")

  success_call_back: ->
    $(".subs").removeClass("disabled")
    @element.remove()

  failure_call_back: (resp) ->
    alert resp.error
  ".forgot -> click": (ev) ->
    ev.preventDefault()
    @element.hide()
    @element.next().show()

$.Controller "ForgotController", "FormController",
  init: ->
    @super_call("init")

  success_call_back:(resp) ->
    alert resp.msg
    @element.hide()

  failure_call_back: (resp) ->
    alert resp.error

  ".login -> click": (ev) ->
    ev.preventDefault()
    @element.hide()
    @element.prev().show()

