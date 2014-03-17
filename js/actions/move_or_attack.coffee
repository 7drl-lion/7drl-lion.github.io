class MoveOrAttack extends Action
  target: TARGET_DIR8

  run: (dir, opts={}) ->
    [i, j] = @state.get_adjacent_pos @id, dir

    if @state.is_creature i, j
      @execute_action 'attack', dir, opts

    else
      @execute_action 'move', dir

register_action 'move_or_attack', MoveOrAttack
