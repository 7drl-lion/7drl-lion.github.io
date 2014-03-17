root = exports ? this

class Actor
  constructor: (@id, @scheduler, @state) ->
    @acting = false
    @removed = ->
    @geas = null

  on_remove: (fn) ->
    @removed = fn

  act: ->
    throw new Error 'Already acting!' if @acting
    @acting = true

    if @_removed_check()
      @removed()
      return

    if @geas
      @run_geas()
      @after_geas_run()
      return

    @on_act()

  done: (speed) ->
    speed ?= @state.get_speed @id

    @scheduler.setDuration speed
    @acting = false

  add_geas: (geas) ->
    @geas = geas
    @geas.start()

  run_geas: ->
    @geas.run()
    @geas = null unless @geas.active()

    @done()
    @on_geas_done()

  on_geas_done: ->
  after_geas_run: ->

  execute_action: (name, args...) ->
    Action = get_action name
    action = new Action @id, @state
    action.run args...

  _removed_check: ->
    not @state.exists @id

actors = []
actors_by_key = {}

register_actor = (key, actor) ->
  r = actor

  actors.push r
  actors_by_key[key] = r

list_actors = ->
  actors

get_actor = (key) ->
  actors_by_key[key]

root.Actor = Actor
root.register_actor = register_actor
root.list_actors = list_actors
root.get_actor = get_actor
