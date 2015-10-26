React = require 'react/addons'
_ = require 'lodash'
Item = React.createFactory require './item'
ItemModel = require './item-model'
SortableList = React.createFactory require '../lib/sortable-list'

RD = React.DOM
cs = React.addons.classSet

module.exports = React.createClass
  displayName: 'Items'

  getInitialState: ->
    editing: false

  render: ->
    items = ItemModel.curated @props.items

    if _.any(items, isChecked: true)
      clearCompleted = RD.button onClick: @props.onClearCompleted,
        RD.i className: 'fa fa-ban'

    itemsList = if items.length
      SortableList
        ref: 'list'
        el: 'ul'
        handleClass: 'sort-handle'
        onSortingUpdate: (ids)=>
          _.each ids, (id, index)=>
            @props.onUpdate id, order: index
      , _.map items, (item, index)=>
        id = item.id
        Item
          ref: id
          key: id
          id: id
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
      className: cs
        'items': true
        'editing': @state.editing
      RD.header null,
        RD.h1 null, @props.listName
        RD.button className: 'back', onClick: @_onBack,
          RD.i className: 'fa fa-chevron-left'
        RD.button className: 'edit', onClick: @_toggleEditing,
          if @state.editing then RD.span null, 'Done' else RD.i className: 'fa fa-sort'
      itemsList
      RD.footer null,
        RD.button onClick: @props.onAdd,
          RD.i className: 'fa fa-plus'
        clearCompleted

  edit: (id)->
    @refs[id].edit()

  _onBack: ->
    @_setEditing false
    @props.onShowLists()

  _toggleEditing: ->
    @_setEditing !@state.editing

  _setEditing: (editing)->
    @setState { editing }
