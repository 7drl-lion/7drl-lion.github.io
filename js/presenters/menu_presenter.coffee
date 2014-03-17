root = exports ? this

class MenuPresenter
  constructor: (@parent, @title, @content, @overlay, @menu_parent) ->

  update: ->
    menu = @menu_parent.menu

    if menu
      @show_menu true

      @title.html menu.title
      @content.html @make_choices menu, menu.choices

    else
      @show_menu false

  show_menu: (val=true) ->
    if val
      $(@parent).show()
      $(@overlay).show()
    else
      $(@parent).hide()
      $(@overlay).hide()

  make_choices: (menu, choices) ->
    content = []

    $.each choices, (i, data) =>
      content.push @make_choice menu, data...

    content

  make_choice: (menu, key, option) ->
    opt = $ '<div/>', class: 'menu_option'
    opt.html "#{key}: "

    link = $('<a/>', href: "#").html option.name
    link.click -> menu.choose key

    opt.append link

root.MenuPresenter = MenuPresenter
