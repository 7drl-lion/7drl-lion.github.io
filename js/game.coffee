root = exports ? this

class Game
  constructor: () ->
    @state = new GameState 84, 24

    @update_callbacks = []

    @scheduler = new ROT.Scheduler.Action()
    @engine = new ROT.Engine @scheduler

  on_key: (args...) ->
    if @menu
      @menu.on_key args...

    else if @player_actor
      @player_actor.on_key args...

  start: ->
    @prompt_character()

  prompt_character: ->
    @prompt_gender (gender) =>
      @prompt_race (race) =>
        @prompt_class (klass) =>
          @create_player gender, race, klass
          @new_floor()

  prompt_gender: (cb) ->
    @show_menu new Menu "Choose your gender: ", list_genders(), (gender) =>
      @show_menu null
      cb gender

  prompt_race: (cb) ->
    @show_menu new Menu "Choose your race: ", list_races(), (race) =>
      @show_menu null
      cb race

  prompt_class: (cb) ->
    @show_menu new Menu "Choose your class: ", list_classes(), (klass) =>
      @show_menu null
      cb klass

  show_menu: (menu) ->
    @menu = menu
    @update()

  create_player: (gender, race, klass) ->
    @player_id = @state.generate_player gender, race, klass

    Player = get_actor 'player'
    @player_actor = new Player @player_id, @scheduler, @engine, @state, => @update()
    @scheduler.add @player_actor, true, 0
    @state.register_actor @player_id, @player_actor

    @player_actor.on_remove =>
      @state.msg @player_id, 'GAME OVER!'
      @update()

      @scheduler.clear()
      @state.unregister_actor @player_id
      @player_actor = null

    @engine.start()

  on_update: (fn) ->
    @update_callbacks.push fn
    fn()

  update: ->
    $.each @update_callbacks, -> @()

  new_floor: ->
    @state.next_floor()
    @state.generate_cave()

    [i, j] = @state.random_empty_space()
    @state.add_entrance i, j
    @state.set_pos @player_id, i, j

    $(15).times => @_generate_trash()
    $(5).times => @_generate_uncommon()
    $(1).times => @_generate_boss()

    [i, j] = @state.random_empty_space()
    @state.add_exit i, j
    @state.add_trigger i, j, (id) =>
      if id == @state.player_id
        if @state.exit_locked
          @state.msg @player_id, 'The exit is locked. You must find and defeat the boss of this level to proceed.'
        else
          @new_floor()

    @map_ready = true
    @update()

  _generate_trash: ->
    id = @state.generate_monster 'trash'
    @_make_actor id, =>
      @_surge 0.12
      @_grant_xp 0.06
      @_check_full_surge()

      @update()

    [x, y] = @state.random_empty_space()
    @state.set_pos id, x, y

  _generate_uncommon: ->
    id = @state.generate_monster 'uncommon'
    @_make_actor id, =>
      @_surge 0.4
      @_grant_xp 0.2
      @_check_full_surge()

      @update()

    [x, y] = @state.random_empty_space()
    @state.set_pos id, x, y

  _generate_boss: ->
    id = @state.generate_monster 'rare'
    @_make_actor id, =>
      @_surge 1
      @_grant_xp 1
      @_check_full_surge()
      @_grant_skill()

      @state.unlock_exit()
      @state.msg @player_id, 'You hear a clicking sound in the distance. (You may now exit this floor.)'

      @update()

    [x, y] = @state.random_empty_space()
    @state.set_pos id, x, y

  _grant_skill: ->
    skills = @state.get_skills @player_id
    all_skills = list_skill_keys()

    skill_set = {}
    _.each skills, (skill) -> skill_set[skill.key] = true

    new_skills = []
    _.each all_skills, (skill) ->
      new_skills.push skill unless skill_set[skill]

    return if new_skills.length == 0

    new_skill = $(new_skills).random_element()

    @state.msg @player_id, "You learn #{new_skill}!"
    @state.give_skill @player_id, new_skill

  _surge: (chance) ->
    return unless Math.random() < chance

    r = Math.random()
    if r < 0.4 then @_health_surge()
    else if r < 0.8 then @_magic_surge()
    else
      @_health_surge()
      @_magic_surge()

  _check_full_surge: ->
    @_full_surge() if @state.monster_count() == 0

  _full_surge: ->
    @state.restore_hp @player_id, @state.get_max_hp @player_id
    @state.restore_mp @player_id, @state.get_max_mp @player_id
    @state.msg @player_id, 'With all the enemies vanquished, you are able to rest. Health and magic restored.'

  _health_surge: ->
    @state.restore_hp @player_id, 10
    @state.msg @player_id, 'You feel a surge of healing energy.'

  _magic_surge: ->
    @state.restore_mp @player_id, 10
    @state.msg @player_id, 'You feel a surge of magic energy.'

  _grant_xp: (xp) ->
    @state.grant_xp @player_id, xp

  _make_actor: (id, cb) ->
    cb ?= ->

    AggressiveMob = get_actor 'aggressive'
    monster_actor = new AggressiveMob id, @scheduler, @engine, @state
    @scheduler.add monster_actor, true, 0
    @state.register_actor id, monster_actor

    monster_actor.on_remove =>
      @scheduler.remove monster_actor
      @state.unregister_actor id

      cb()

root.Game = Game
