class Wait extends Action
  target: TARGET_NONE

  run: ->
    true

register_action 'wait', Wait
