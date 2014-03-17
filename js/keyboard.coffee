root = exports ? this

class Keyboard
  NAMES =
    27: 'esc', 37: 'left', 38: 'up', 39: 'right', 40: 'down', 32: 'space',
    48: '0', 49: '1', 50: '2', 51: '3', 52: '4', 53: '5', 54: '6', 55: '7', 56: '8', 57: '9',
    96: 'num0', 97: 'num1', 98: 'num2', 99: 'num3', 100: 'num4', 101: 'num5', 102: 'num6', 103: 'num7', 104: 'num8', 105: 'num9',
    65: 'a', 66: 'b', 67: 'c', 68: 'd', 69: 'e', 70: 'f', 71: 'g', 72: 'h', 73: 'i', 74: 'j',
    75: 'k', 76: 'l', 77: 'm', 78: 'n', 79: 'o', 80: 'p', 81: 'q', 82: 'r', 83: 's', 84: 't',
    85: 'u', 86: 'v', 87: 'w', 88: 'x', 89: 'y', 90: 'z'

  constructor: ->
    @elem = window
    @target = null

    $(@elem).keydown @key_down

  set_target: (target) ->
    @target = target

  clear_target: ->
    @target = null

  key_down: (e) =>
    return unless @target

    name = NAMES[e.which]
    return unless name

    mods =
      shift: e.shiftKey
      ctrl: e.ctrlKey

    @target.on_key name, mods

root.Keyboard = Keyboard
