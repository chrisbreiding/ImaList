class Item

  props: ['name', 'isChecked']

  constructor: (props)->
    @name = props.name
    @isChecked = props.isChecked ? false

  toggleChecked: ->
    @isChecked = !@isChecked

Item.newOne = ->
  name: ''
  isChecked: false

module.exports = Item
