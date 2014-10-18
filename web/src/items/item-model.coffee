class Item

  props: ['name', 'isChecked']

  constructor: (props)->
    for propName in @props
      @[propName] = props[propName]

  toggleChecked: ->
    @isChecked = !@isChecked

Item.newOne = ->
  name: ''
  isChecked: false

module.exports = Item
