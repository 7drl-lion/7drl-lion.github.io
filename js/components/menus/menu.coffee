root = exports ? this

class Menu
  KEYS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

  constructor: (@title, options, @cb) ->
    @make_choices options

  make_choices: (options) ->
    @choices = []
    @choice_map = {}

    $.each options, (i, v) =>
      @choices.push [KEYS[i], v]
      @choice_map[KEYS[i]] = v

  on_key: (key, mods) ->
    key = key.toUpperCase() if mods.shift
    @choose key

  choose: (key) ->
    @cb @choice_map[key] if @choice_map[key]

root.Menu = Menu
