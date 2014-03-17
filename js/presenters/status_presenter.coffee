root = exports ? this

class StatusPresenter
  constructor: (@parent, @game) ->
    @level = $('<span/>', id: 'level').append '0'
    @race = $('<span/>', id: 'race').append ''
    @class = $('<span/>', id: 'class').append 'unknown'

    @parent.append("Lvl ").append(@level).append(" ").append(@race).append(" ").append(@class).append("<br /><br />")

    @hp = $("<b/>", id: 'hp').html "0 / 0"
    @hp_bar = $("<b/>", id: 'hp_bar')
    @parent.append("HP: ").append(@hp).append(" ").append(@hp_bar).append("<br />")

    @mp = $("<b/>", id: 'mp').html "0 / 0"
    @mp_bar = $("<b/>", id: 'mp_bar')
    @parent.append("MP: ").append(@mp).append(" ").append(@mp_bar).append("<br />")

    @xp = $("<b/>", id: 'xp').html "0%"
    @xp_bar = $("<b/>", id: 'xp_bar')
    @parent.append("XP: ").append(@xp).append(" ").append(@xp_bar).append("<br /><br />")

    @floor = $("<span/>", id: 'floor').html 0
    @enemies = $("<span/>", id: 'enemies').html 0
    @parent.append("FLOOR ").append(@floor).append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;enemies: ").append(@enemies)

  update: ->
    state = @game.state
    player = state._player

    unless player
      return

    @level.html player.level
    @race.html player.race.name
    @class.html player.class.name

    xp_percent_str = _.str.numberFormat((player.xp * 100), 0)
    padded_xp = @_nbsp_pad "#{xp_percent_str}%", 10
    @xp.html padded_xp
    @xp_bar.html @_bar('xp', player.xp, 15)

    hp_pct = player.hp / player.max_hp
    hp_str = "#{player.hp} / #{player.max_hp}"
    padded_hp = @_nbsp_pad hp_str, 10
    @hp.html padded_hp
    @hp_bar.html @_bar('hp', hp_pct, 15)

    mp_pct = player.mp / player.max_mp
    mp_str = "#{player.mp} / #{player.max_mp}"
    padded_mp = @_nbsp_pad mp_str, 10
    @mp.html padded_mp
    @mp_bar.html @_bar('mp', mp_pct, 15)

    @floor.html state.floor
    @enemies.html state.monster_count()

  _nbsp_pad: (str, n) ->
    _.str.rpad(str, n, "&").replace(/&/g, "&nbsp;")

  _bar: (klass, pct, length) ->
    num_bars = Math.round(pct * (length - 2))
    num_spaces = (length - 2) - num_bars

    bars = _.str.repeat "=", num_bars
    spaces = _.str.repeat "-", num_spaces

    "<span class='bar #{klass}'><span class='filled'>|#{bars}<span class='empty'>#{spaces}</span>|</span></span>"

root.StatusPresenter = StatusPresenter
