root = exports ? this

class HelpPresenter
  constructor: (@parent, @game) ->
    @one_time = false

    @parent.html "Move: <br />" +
      "&nbsp;&nbsp;* <b>arrow keys</b><br />" +
      "&nbsp;&nbsp;* <b>num pad</b><br />" +
      "&nbsp;&nbsp;* <b>hjkl</b> and <b>yubn</b><br />" +
      "<br />" +
      "Wait: <br />" +
      "&nbsp;&nbsp;* <b>space</b><br />" +
      "<br />" +
      "Skills: <br />" +
      "&nbsp;&nbsp;* <b>1-9</b> and <b>0</b><br />" +
      "<br />" +
      "GOALS:<br />" +
      "&nbsp;&nbsp;* <b>kill the boss</b> to proceed<br />" +
      "&nbsp;&nbsp;&nbsp;&nbsp;and <b>learn skills</b><br />" +
      "&nbsp;&nbsp;* enemies may grant <b>healing</b><br />" +
      "&nbsp;&nbsp;* clear level for <b>full heal</b>"

root.HelpPresenter = HelpPresenter
