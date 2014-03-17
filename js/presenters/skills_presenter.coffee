root = exports ? this

class SkillsPresenter
  constructor: (@parent, @game) ->
    @skills = []
    @skill_costs = []

    $(10).times (i) =>
      cost = $('<span/>', class: 'cost')
      cost.append " ("
      skill_cost = $('<span/>', id: "skill_#{i}_cost").html "0 mp"
      cost.append skill_cost
      cost.append ")"

      skill = $('<div />', class: 'skill')
      skill.append "#{(i + 1) % 10}: "
      skill_name = $('<span/>', id: "skill_#{i}", class: 'disabled').html 'none'
      skill.append skill_name
      skill.append cost

      @parent.append skill

      @skills.push skill_name
      @skill_costs.push skill_cost

  update: ->
    state = @game.state
    player = state._player

    unless player
      return

    skills = player.skills

    $(10).times (i) =>
      skill = skills[i]

      if skill
        @skills[i].removeClass 'disabled'
        @skills[i].html skill.name

        if skill.mp > player.mp
          @skill_costs[i].addClass 'invalid'
        else
          @skill_costs[i].removeClass 'invalid'

        @skill_costs[i].html "#{skill.mp} mp"

      else
        @skills[i].addClass 'disabled'
        @skills[i].html 'none'
        @skill_costs[i].removeClass 'invalid'
        @skill_costs[i].html "0 mp"

  _present_skill: (player, key, skill) ->
    unless skill
      return "<span class='disabled'>#{key}: none</span>"

    if skill.mp > player.mp
      "<span class='disabled'>#{key}: #{skill.name}</span> (<span class='invalid'>#{skill.mp} mp</span>)"
    else
      "<b>#{key}</b>: <b>#{skill.name}</b> (#{skill.mp} mp)"

root.SkillsPresenter = SkillsPresenter
