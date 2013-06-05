$.Controller "HomeFormController",
  init: ->
    @load_details()
  

  "#region_id -> change":(ev) ->
    id = $(ev.target).val()
    @load_details(id)

  load_details: (id) ->
    id = id || 0
    select = @element.find("#penalty_payment_detail_id")
    $.ajax
      url:"/home/index"
      data:"region_id="+id
      dataType:"json"
      success:(resp) ->
        select.html("").append(resp.regions)
        $.jNice.SelectUpdate(select)

