module.exports = class Item

  props: ['name', 'isChecked']

  constructor: (props)->
    for propName in @props
      @[propName] = props[propName]

  toggleChecked: ->
    @isChecked = !@isChecked
