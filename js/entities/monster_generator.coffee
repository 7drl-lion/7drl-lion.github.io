root = exports ? this

class MonsterGenerator extends EntityGenerator
  generate: (rarity, floor) ->
    alignment = $(list_alignments()).random_element()
    gender = $(list_genders()).random_element()
    race = $(list_races_for_alignment(alignment.key)).random_element()
    klass = $(list_classes_for_alignment_and_race(alignment.key, race.key)).random_element()

    scaling_factor = switch rarity
      when 'trash' then 0.1
      when 'uncommon' then 0.2
      when 'rare' then 0.4

    scaling_factor += scaling_factor * (floor - 1) * 0.2

    base_attack = gender.base_attack + race.base_attack + klass.base_attack
    base_attack = Math.ceil(base_attack * scaling_factor)

    base_hp = gender.base_hp + race.base_hp + klass.base_hp
    base_hp = Math.ceil(base_hp * scaling_factor)

    base_mp = gender.base_mp + race.base_mp + klass.base_mp
    base_mp = Math.ceil(base_mp * scaling_factor)

    base_speed = gender.base_speed + race.base_speed + klass.base_speed
    base_speed = Math.ceil(base_speed * Math.pow(0.9, (floor - 1)))

    skill = $(list_monster_skill_keys()).random_element()

    new Entity
      id: @generate_id()
      x: 0, y: 0
      level: 1
      gender: gender
      race: race
      class: klass
      base_attack: base_attack
      base_speed: base_speed
      base_hp: base_hp
      base_mp: base_mp
      dead: false
      rarity: rarity
      skills: [skill]

root.MonsterGenerator = MonsterGenerator
