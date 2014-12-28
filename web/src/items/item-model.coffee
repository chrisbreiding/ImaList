Collection = require '../lib/collection'

module.exports = class Item extends Collection

  constructor: (props)->
    @order = props.order
    @name = props.name
    @isChecked = props.isChecked ? false

  toggleChecked: ->
    @isChecked = !@isChecked

  @newOne: (order)->
    order: order
    name: ''
    isChecked: false
