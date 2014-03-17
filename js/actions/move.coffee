class Move extends Action
  target: TARGET_DIR8

  run: (dir) ->
    [i, j] = @state.get_adjacent_pos @id, dir

    unless @state.is_blocked i, j
      @state.set_pos @id, i, j
      @state.set_off_triggers @id

      true

    else
      @state.msg @id, "You can't go that way."
      false

register_action 'move', Move
