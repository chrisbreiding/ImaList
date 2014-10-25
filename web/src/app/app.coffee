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
      Lists
        lists: lists
        onListSelect: @_showItems
      Items
        ref: 'items'
        listName: selectedList.name
        items: selectedList.items
        onBack: @_showLists
        onAdd: @_add
        onUpdate: _.partial @_itemUpdated, selectedListId
        onRemove: _.partial @_itemRemoved, selectedListId

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

  _itemRemoved: (listId, itemId)->
    itemRef = @firebaseRefs.lists.child "#{listId}/items/#{itemId}"
    itemRef.remove()

