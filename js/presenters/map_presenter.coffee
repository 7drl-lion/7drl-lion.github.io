root = exports ? this

FLOOR_REPS =
  empty: { rep:' ', color:[0,0,0] }
  floor: { rep:'.', color:[51, 51, 51] }
  entrance: { rep:'<', color:[80, 80, 80] }
  exit: { rep:'>', color:[0, 255, 255] }

WALL_REPS =
  wall: { rep:'#', color:[102, 102, 102] }

CREATURE_REPS =
  player: '@'
  angel: 'a'
  catfolk: 'c'
  centaur: 'C'
  demon: 'd'
  dragon: 'D'
  dragonkin: 'k'
  dwarf: 'w'
  elf: 'e'
  gnome: 'g'
  giant: 'G'
  hobbit: 'i'
  human: 'h'
  shapeshifter: 's'
  werewolf: 'w'

CREATURE_COLORS =
  player: [255, 255, 255]
  trash: [80, 80, 50]
  uncommon: [80, 50, 255]
  rare: [255, 0, 0]

class MapPresenter
  constructor: (@parent, @data_parent) ->
    @display = new ROT.Display 1, 3, { width: 1, height: 1 }
    @parent.append @display.getContainer()

    @state = @data_parent.state

    @display.setOptions
      width: @state.map_width
      height: @state.map_height
      fontSize: 14
      fontFamily: "monospace"
      bg: "#000000"
      layout: 'rect'

  update: ->
    unless @data_parent.map_ready
      @parent.hide()
      return

    state = @data_parent.state

    @parent.show()

    @display.clear()

    light_map = {}
    fov_map = {}

    light_passes = (x, y) =>
      not @state.is_wall x, y

    player = state.player_id
    return unless @state.exists player

    [pi,pj] = state.get_pos player

    fov = new ROT.FOV.PreciseShadowcasting light_passes, topology: 8
    fov.compute pi, pj, 24, (x, y, r, visibility) ->
      fov_map["#{x},#{y}"] = visibility

    reflectivity = (x, y) =>
      if @state.is_wall(x, y) then 0.0 else 1.0

    light_fov = new ROT.FOV.PreciseShadowcasting light_passes, topology: 4
    lighting = new ROT.Lighting reflectivity, range: 4, passes: 1
    lighting.setFOV light_fov

    lighting.setLight pi, pj, [255, 255, 255]

    lighting.compute (x, y, color) ->
      light_map["#{x},#{y}"] = color

    ambient_light = [200, 200, 200]

    $.each fov_map, (pos) =>
      [x, y] = pos.split ","
      i = parseInt x
      j = parseInt y

      r = @convert @state.get_data(i, j)
      base_color = r.color
      light = ambient_light

      if light_map["#{i},#{j}"]
        light = ROT.Color.add light, light_map["#{i},#{j}"]

      final_color = ROT.Color.multiply base_color, light
      if fov_map["#{i},#{j}"]
        v = fov_map["#{i},#{j}"]
        visible_color = ROT.Color.multiply final_color, [255*v, 255*v, 255*v]

        @display.draw j,  i, r.rep, ROT.Color.toRGB visible_color

  convert: (stack) ->
    rep = FLOOR_REPS['empty']

    if stack[FLOORS]
      rep = FLOOR_REPS[stack[FLOORS]]
      throw new Error("Could not find rep for '#{stack[FLOORS]}'") unless rep

    if stack[WALLS]
      rep = WALL_REPS[stack[WALLS]]
      throw new Error("Could not find rep for '#{stack[WALLS]}'") unless rep

    if stack[CREATURES]
      entity = stack[CREATURES]
      is_player = entity.id == @state.player_id
      key = if is_player then 'player' else entity.race.key
      rep = { rep: CREATURE_REPS[key], color: CREATURE_COLORS[entity.rarity] }
      throw new Error("Could not find rep for '#{key}'") unless rep.rep and rep.color

    rep

root.MapPresenter = MapPresenter
