root = exports ? this

class Gender
  constructor: ->

genders = []
genders_by_key = {}

register_gender = (gender) ->
  g = new gender

  genders.push g
  genders[g.key] = g

list_genders = ->
  genders

get_gender = (key) ->
  genders_by_key[key]

root.Gender = Gender
root.register_gender = register_gender
root.list_genders = list_genders
root.get_gender = get_gender
