$.fn.times = (fn) ->
  n = $(@)[0]
  fn(i) for i in [0...n]

$.fn.times_map = (fn) ->
  result = []

  $(@).times (i) ->
    result.push fn i

  result

$.fn.random_element = (fn) ->
  ary = $(@)
  idx = Math.floor(Math.random() * ary.length)
  @[idx]

$.fn.all = (cb) ->
  all = true

  @each ->
    unless cb(@, @)
      all = false
      return false

  all

$.fn.any = (cb) ->
  any = false

  @each ->
    if !!cb(@, @)
      any = true
      return false

  any
