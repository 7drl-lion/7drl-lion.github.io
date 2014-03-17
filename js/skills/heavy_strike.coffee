class HeavyStrike extends Skill
  target: TARGET_DIR8
  key: 'heavy_strike'
  name: 'heavy strike'
  mp: 5
  cooldown: 5

  run: (dir) ->
    @execute_action 'attack', dir, mod: 1.5, flavor: 'demolish'

register_skill 'heavy_strike', HeavyStrike
register_monster_skill 'heavy_strike', HeavyStrike
