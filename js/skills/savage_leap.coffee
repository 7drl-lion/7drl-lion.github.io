class SavageLeap extends Skill
  target: TARGET_DIR8
  key: 'savage_leap'
  name: 'savage leap'
  mp: 5
  cooldown: 10

  run: (dir) ->
    [i, j] = @state.get_pos @id

    [x, y] = @state.pos_in_direction i, j, dir, 3
    return if @state.is_blocked(x, y)

    adjacent = @state.get_all_adjacent_pos x, y

    has_enemy = []
    _.each adjacent, (pos) =>
      has_enemy.push pos if @state.is_creature pos...

    return if has_enemy.length == 0

    actor_short = @state.get_short_description @id
    @state.msg @id, "You leap into the fray!"
    @state.shout_by @id, "#{_.str.capitalize(actor_short)} leaps into the fray!"

    @state.set_pos @id, x, y

    _.each has_enemy, (pos) =>
      dir = @state.general_direction @id, pos...
      @execute_action 'attack', dir, mod: 0.2, flavor: "stomp"

    true

register_skill 'savage_leap', SavageLeap
