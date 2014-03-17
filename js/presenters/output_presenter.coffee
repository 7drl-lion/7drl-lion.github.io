root = exports ? this

class OutputPresenter
  constructor: (@parent, @game) ->

  update: ->
    state = @game.state
    output = state.output

    @parent.html ""

    $.each output, (i, entry) =>
      @parent.append $('<div/>', class: 'entry').html entry

    @parent.scrollTop @parent[0].scrollHeight

root.OutputPresenter = OutputPresenter
