root = exports ? this

class Alignment
  constructor: (@actor, @state) ->

alignments = []
alignments_by_key = {}

register_alignment = (alignment) ->
  r = new alignment

  alignments.push r
  alignments_by_key[r.key] = r

list_alignments = ->
  alignments

get_alignment = (key) ->
  alignments_by_key[key]

root.Alignment = Alignment
root.register_alignment = register_alignment
root.list_alignments = list_alignments
root.get_alignment = get_alignment
