root = exports ? this

class MapGenerator
  WALL_CHANCE = 0.4

  constructor: (@width, @height) ->

  run: (cb) ->
    @build_floor cb
    @build_walls cb

  build_floor: (cb) ->
    @each (i, j) ->
      cb i, j, FLOORS, 'floor'

  build_walls: (cb) ->
    data = @random_fill WALL_CHANCE

    $(5).times (i) => data = @step data, @condition_one
    $(1).times (i) => data = @step data, @condition_two

    data = @connect_disjoint data

    @each (i, j) ->
      cb i, j, WALLS, 'wall' if data[i][j]

  blank_data: ->
    data = []

    $(@height).times (i) =>
      data[i] = []

      $(@width).times (j) =>
        data[i][j] = false

    data

  copy_data: (data) ->
    @map (i, j) -> data[i][j]

  random_fill: (chance) ->
    @map (i, j) -> (Math.random() < chance)

  step: (data, condition) ->
    @map (i, j) -> condition data, i, j

  condition_one: (data, i, j) =>
    @count_neighbors(data, i, j, 1) > 3 or @count_neighbors(data, i, j, 2) < 2

  condition_two: (data, i, j) =>
    @count_neighbors(data, i, j, 1) > 5

  count_neighbors: (data, i, j, d) ->
    count = 0

    @each_neighbor i, j, d, true, (x, y) =>
      count += 1 if @out_of_bounds(x, y) or data[x][y]

    count

  each_neighbor: (i, j, d, incl, cb) ->
    for ioff in [-d..d]
      for joff in [-d..d]
        unless ioff == 0 and joff == 0
          x = i+ioff
          y = j+joff
          cb x, y if incl or @in_bounds(x, y)

  in_bounds: (i, j) ->
    0 <= i < @height and 0 <= j < @width

  out_of_bounds: (i, j) ->
    not @in_bounds(i, j)

  connect_disjoint: (data) ->
    new_data = @copy_data data

    loop
      regions = @find_disjoint_regions new_data
      break if regions.length <= 1

      [left, right, rest] = regions
      new_data = @connect_regions new_data, left, right

    new_data

  find_disjoint_regions: (data) ->
    new_data = @copy_data data
    regions = []

    loop
      space = @find_next_empty_space new_data
      break unless space

      [i,j] = space

      region = @flood_fill new_data, i, j
      regions.push region

      new_data = @fill_in new_data, region

    regions

  find_next_empty_space: (data) ->
    result = null

    @each (i, j) =>
      result = [i, j] if not result and not data[i][j]

    result

  flood_fill: (data, i, j) ->
    region = []

    heap = new Heap @compare_coords
    explored = @blank_data()

    heap.push [i,j]

    until heap.empty()
      [i, j] = heap.pop()
      continue if explored[i][j]

      explored[i][j] = true
      region.push [i,j]

      @each_neighbor i, j, 1, false, (x, y) =>
        unless data[x][y] or explored[x][y]
          heap.push [x, y]

    region

  fill_in: (data, region) ->
    new_data = @copy_data data

    $.each region, (p, r) =>
      [i,j] = r
      new_data[i][j] = true

    new_data

  compare_coords: (x, y) ->
    [ix,jx] = x
    [iy,jy] = y

    if ix > iy then -1
    else if iy == ix
      if jx > jy then -1
      else if jx == jy then 0
      else 1
    else 1

  connect_regions: (data, left, right) ->
    p1 = $(left).random_element()
    p2 = $(right).random_element()

    @dig_tunnel data, p1, p2

  dig_tunnel: (data, p1, p2) ->
    new_data = @copy_data data

    loop
      [x1, y1] = p1
      [x2, y2] = p2

      break if x1 == x2 and y1 == y2

      xd = x2 - x1
      yd = y2 - y1

      new_data = @blast new_data, x1, y1

      if Math.random() < 0.2
        [dirx,diry] = @choose_dir 0.25, 0.25, 0.25
      else
        [dirx,diry] = @choose_dir @up_chance(xd, yd), @right_chance(xd, yd), @down_chance(xd, yd)

      x3 = x1+dirx
      y3 = y1+diry
      unless @out_of_bounds(x3, y3)
        p1 = [x3, y3]

    new_data

  up_chance: (xd, yd) ->
    return 0 if xd >= 0
    Math.abs(xd) / (Math.abs(yd) + Math.abs(xd))

  right_chance: (xd, yd) ->
    return 0 if yd <= 0
    Math.abs(yd) / (Math.abs(yd) + Math.abs(xd))

  down_chance: (xd, yd) ->
    return 0 if xd <= 0
    Math.abs(xd) / (Math.abs(yd) + Math.abs(xd))

  left_chance: (xd, yd) ->
    return 0 if yd >= 0
    Math.abs(yd) / (Math.abs(yd) + Math.abs(xd))

  choose_dir: (c1, c2, c3) ->
    r = Math.random()

    if r <= c1 then [-1,0]
    else if r <= c1+c2 then [0,1]
    else if r <= c1+c2+c3 then [1,0]
    else [0,-1]

  cmp: (x1, x2) ->
    if x1 < y1 then -1
    else if x1 == y1 then 0
    else 1

  blast: (data, i, j) ->
    new_data = @copy_data data

    new_data[i][j] = false

    @each_neighbor i, j, 1, false, (x, y) =>
      new_data[x][y] = false if Math.random() < 0.2

    new_data

  each: (fn) ->
    $(@height).times (i) =>
      $(@width).times (j) =>
        fn i, j

  map: (fn) ->
    data = @blank_data()

    @each (i, j) ->
      data[i][j] = fn i, j

    data

root.MapGenerator = MapGenerator
