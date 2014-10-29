React = require 'react/addons'
_ = require 'lodash'
Item = React.createFactory require './item'
ItemModel = require './item-model'

RD = React.DOM

module.exports = React.createClass

  render: ->
    items = _.map @props.items, (item, id)->
      item.id = id
      item

    if _.any(@props.items, isChecked: true)
      clearCompleted = RD.button onClick: @props.onClearCompleted,
        RD.i className: 'fa fa-ban'

    RD.div className: 'items',
      RD.header null,
        RD.h1 null, @props.listName
        RD.button onClick: @props.onShowLists,
          RD.i className: 'fa fa-bars'
      RD.ul null, _.map items, (item, index)=>
        id = item.id
        Item
          model: new ItemModel item
          ref: "item-#{id}"
          key: id
          onUpdate: _.partial @props.onUpdate, id
          onRemove: _.partial @props.onRemove, id
          onNext: if index is items.length - 1
            @props.onAdd
          else
            _.partial @editItem, items[index + 1].id
      RD.footer null,
        RD.button onClick: @props.onAdd,
          RD.i className: 'fa fa-plus'
        clearCompleted

  editItem: (id)->
    @refs["item-#{id}"].edit()
