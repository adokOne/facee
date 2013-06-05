$.Controller "DetailsFormController", "FormController",
  init: ->
    @element.find("#datepicker").datepicker()
  submit: ->

$.Controller "BookingFormController", "FormController",
  init: ->
    @super_call("init")
    $.publish("price/change")
    @init_popup()
  submit: ->
  setup_submit: ->
    @element.ajaxformbar
      success:(resp)->
        if resp.success
          window.location.href = resp.url
        else
          alert resp.error
    form = @element
    $(".submit").click (ev) ->
      ev.preventDefault()
      if $("#eula_accept").is(":checked")
        form.data("ajaxformbar").el.submit()

  init_popup: ->
    $("body").prepend($(".popup"))
    $(".license_pop_up").click ->
       $(".popup , .pop_up_bg").fadeIn 500
    $(".pop_up_bg").click ->
      $(".popup , .pop_up_bg").fadeOut 500
    $("#scrollbar").tinyscrollbar
      sizethumb: 20
      size: 368

  "#penalty_has_invoice -> change":(ev)->
    if $(ev.target).is(":checked")
      @element.find(".gray").addClass("to_calc")
    else 
      @element.find(".gray").removeClass("to_calc")
    $.publish("price/change")
,
  "price/change": ->
    p_elems = @element.find(".to_calc")
    price = 0
    for el in p_elems
      price += Number($(el).text().split(" ")[0])
    @element.find(".summ.red .last").text(price + " ГРН")

