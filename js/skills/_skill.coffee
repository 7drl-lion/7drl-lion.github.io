root = exports ? this

class Skill extends Action

skills = []
skills_by_key = {}

register_skill = (key, skill) ->
  r = skill

  skills.push r
  skills_by_key[key] = r

list_skills = ->
  skills

list_skill_keys = ->
  keys = []

  _.each skills, (Skill) ->
    skill = new Skill()
    keys.push skill.key

  keys

get_skill = (key) ->
  skills_by_key[key]

monster_skills = []
monster_skills_by_key = {}

register_monster_skill = (key, monster_skill) ->
  r = monster_skill

  monster_skills.push r
  monster_skills_by_key[key] = r

list_monster_skills = ->
  monster_skills

list_monster_skill_keys = ->
  keys = []

  _.each monster_skills, (Skill) ->
    monster_skill = new Skill()
    keys.push monster_skill.key

  keys

get_monster_skill = (key) ->
  monster_skills_by_key[key]

root.Skill = Skill
root.register_skill = register_skill
root.list_skills = list_skills
root.list_skill_keys = list_skill_keys
root.get_skill = get_skill
root.register_monster_skill = register_monster_skill
root.list_monster_skills = list_monster_skills
root.list_monster_skill_keys = list_monster_skill_keys
root.get_monster_skill = get_monster_skill
