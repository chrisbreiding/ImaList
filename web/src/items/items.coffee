React = require 'react'
_ = require 'lodash'
Item = require './item'
ItemModel = require './item-model'

module.exports = React.createClass

  render: ->
    React.DOM.ul className: 'items', _.map @props.items, (item, id)=>
      Item
        model: new ItemModel item
        ref: "item-#{id}"
        key: id
        onUpdate: _.partial @props.onUpdate, id
        onRemove: _.partial @props.onRemove, id

  add: (id)->
    @refs["item-#{id}"].edit()
