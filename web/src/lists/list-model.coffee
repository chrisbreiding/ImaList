Collection = require '../lib/collection'

module.exports = class List extends Collection

  constructor: (props)->
    @order = props.order
    @name = props.name
    @items = props.items or {}
    @owner = props.owner
    @shared = props.shared or false

  @newOne: (order, owner)->
    order: order
    name: ''
    items: {}
    owner: owner
    shared: false
