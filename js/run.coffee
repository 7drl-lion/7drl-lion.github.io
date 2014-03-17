root = exports ? this

keyboard = null

$(document).ready ->
  create_layout()

  keyboard = new Keyboard $('#game')

  game = new Game()
  presenter = new GamePresenter game
  game.on_update -> presenter.update()
  keyboard.set_target game

  game.start()
