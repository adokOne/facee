$.Controller "AdminUsersController",
  init: ->
  ".sortable -> click":(ev)->
    el = if $(ev.target).hasClass("sortable") then $(ev.target) else $(ev.target).parents(".sortable")
    el.find("form").submit()