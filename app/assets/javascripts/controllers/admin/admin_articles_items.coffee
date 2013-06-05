$.Controller "AdminArticlesItemsController",

  modal_init: false,

  ".row-fluid.header a -> click": (ev) ->
    return if @parent.modal_init
    el = if $(ev.target).hasClass("success") then $(ev.target) else $(ev.target).parent()
    @get_form(el.data("type"))

  ".btn-flat.success.edit -> click": (ev) ->
    return if @parent.modal_init
    @get_form($(ev.target).data("type"),$(ev.target).data("id"))

  ".btn-flat.danger.delete -> click": (ev) ->
    @delete($(ev.target).data("id"),$(ev.target).data("type"))

  delete: (id,type) ->
    $.ajax
      url:"/admin/articles/delete_dic/" + id
      type: "get"
      data: "delete=" + type
      dataType: "json"
      success: (resp) ->
        window.location.reload()

  change_modal_init:(type) ->
    @parent.modal_init = type

  get_form: (type,id) ->
    id = id || 0
    self = @
    $.ajax
      url:"/admin/articles/get_form/" + id
      type: "get"
      data: "edit=" + type
      dataType: "json"
      success: (resp) ->
        $("body").append resp.html
        self.change_modal_init true
        $(".modal")



 ,
   "close_modal": ->
     @parent.modal_init = false
     $(".modal").remove()

   "submit_data": (el) ->
     $(el).parents(".modal").find("form").submit()