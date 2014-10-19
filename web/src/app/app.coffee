React = require 'react'
_ = require 'lodash'
Firebase = require 'firebase'
ReactFireMixin = require 'reactfire'
Lists = require '../lists/lists'
Items = require '../items/items'
ItemModel = require '../items/item-model'

RD = React.DOM

module.exports = React.createClass

  mixins: [ReactFireMixin]

  getInitialState: ->
    lists: []
    selectedListId: JSON.parse localStorage.selectedListId ? 'null'

  componentWillMount: ->
    @bindAsObject new Firebase('https://imalist.firebaseio.com/lists/'), 'lists'

  componentDidUpdate: ->
    localStorage.selectedListId = JSON.stringify @state.selectedListId

  render: ->
    lists = @state.lists

    userSelectedId = @state.selectedListId ? null

    selectedListId = userSelectedId ? Object.keys(lists)[0]
    selectedList = @state.lists[selectedListId] or items: {}

    className = if userSelectedId then 'app showing-items' else 'app'

    RD.div className: className,
      RD.header null,
        RD.h1 null, if userSelectedId and selectedList.name? then selectedList.name else 'ImaList'
        RD.button onClick: @_showLists,
          RD.i className: 'fa fa-chevron-left'
      Lists lists: lists, onListSelect: @_showItems
      Items ref: 'items', items: selectedList.items, onUpdate: _.partial @_itemUpdated, selectedListId
      RD.footer null,
        RD.button onClick: @_add,
          RD.i className: 'fa fa-plus'

  _showItems: (id)->
    @setState selectedListId: id

  _showLists: ->
    @setState selectedListId: null

  _add: ->
    if @state.selectedListId
      itemsRef = @firebaseRefs.lists.child "#{@state.selectedListId}/items/"
      items = @state.lists[@state.selectedListId].items or {}
      keys = Object.keys items

      unless keys.length
        @_addItem itemsRef, 0
        return

      lastItemRef = itemsRef.child keys[keys.length - 1]
      lastItemRef.once 'child_added', (snapshot)=>
        priority = snapshot.getPriority()
        @_addItem itemsRef, if priority? then priority + 1 else 0

  _addItem: (itemsRef, priority)->
    newItemRef = itemsRef.push()
    newItemRef.setWithPriority ItemModel.newOne(), priority, =>
      @refs.items.add newItemRef.name()

  _itemUpdated: (listId, itemId, item)->
    itemRef = @firebaseRefs.lists.child "#{listId}/items/#{itemId}"
    itemRef.update item
