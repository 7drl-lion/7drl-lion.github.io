root = exports ? this

class Tile
  constructor: (flags=[]) ->
    @flags = {}
    $(flags).each (i, flag) => @add_flag flag

  get_flags: ->
    $.map @flags, (v,k) -> k

  clear: ->
    @flags = {}

  add_flag: (flag) ->
    @flags[flag] = true

  has_flag: (flag) ->
    @flags.hasOwnProperty(flag)

root.Tile = Tile
