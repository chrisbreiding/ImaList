React = require 'react/addons'
_ = require 'lodash'
Item = React.createFactory require './item'
ItemModel = require './item-model'

RD = React.DOM

module.exports = React.createClass

  render: ->
    items = ItemModel.curated @props.items

    if _.any(items, isChecked: true)
      clearCompleted = RD.button onClick: @props.onClearCompleted,
        RD.i className: 'fa fa-ban'

    itemsList = if items.length
      RD.ul null, _.map items, (item, index)=>
        id = item.id
        Item
          ref: id
          key: id
          model: new ItemModel item
          onUpdate: _.partial @props.onUpdate, id
          onRemove: _.partial @props.onRemove, id
          onNext: if index is items.length - 1
            @props.onAdd
          else
            _.partial @edit, items[index + 1].id
    else
      RD.p
        className: 'no-items'
        'No Items'

    RD.div
      className: 'items'
      RD.header null,
        RD.h1 null, @props.listName
        RD.button onClick: @props.onShowLists,
          RD.i className: 'fa fa-chevron-left'
      itemsList
      RD.footer null,
        RD.button onClick: @props.onAdd,
          RD.i className: 'fa fa-plus'
        clearCompleted

  edit: (id)->
    @refs[id].edit()
