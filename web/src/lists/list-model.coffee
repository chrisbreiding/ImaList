class List

  props: ['name', 'items']

  constructor: (props)->
    @name = props.name
    @items = props.items or {}

List.newOne = ->
  name: ''
  items: {}

module.exports = List
