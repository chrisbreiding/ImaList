class List

  props: ['name', 'items']

  constructor: (props)->
    for propName in @props
      @[propName] = props[propName]

List.newOne = ->
  name: ''
  items: {}

module.exports = List
