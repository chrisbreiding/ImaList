React = require 'react'
_ = require 'lodash'
Item = require './item'
ItemModel = require './item-model'

RD = React.DOM

module.exports = React.createClass

  render: ->
    RD.div className: 'items',
      RD.header null,
        RD.h1 null, @props.listName
        RD.button onClick: @props.onToggleLists,
          RD.i className: 'fa fa-bars'
      RD.ul null, _.map @props.items, (item, id)=>
        Item
          model: new ItemModel item
          ref: "item-#{id}"
          key: id
          onUpdate: _.partial @props.onUpdate, id
          onRemove: _.partial @props.onRemove, id
      RD.footer null,
        RD.button onClick: @props.onAdd,
          RD.i className: 'fa fa-plus'

  add: (id)->
    @refs["item-#{id}"].edit()
