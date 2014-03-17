root = exports ? this

class EntityGenerator
  generate_id: ->
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
      r = Math.random() * 16 | 0
      v = (if c == 'x' then r else (r & 0x3 | 0x8))
      v.toString 16

root.EntityGenerator = EntityGenerator