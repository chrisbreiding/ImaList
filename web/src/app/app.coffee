React = require 'react/addons'
_ = require 'lodash'
Firebase = require 'firebase'
ReactFireMixin = require 'reactfire'
Lists = require '../lists/lists'
Items = require '../items/items'
ItemModel = require '../items/item-model'
ActionSheet = require '../action-sheet/action-sheet'

RD = React.DOM
cs = React.addons.classSet

module.exports = React.createClass

  mixins: [ReactFireMixin]

  getInitialState: ->
    lists: []
    showItems: localStorage.selectedListId?
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

    RD.div
      className: cs
        'app': true
        'showing-items': @state.showItems
      Lists
        lists: lists
        onListSelect: @_showItems
      Items
        ref: 'items'
        listName: selectedList.name
        items: selectedList.items
        onToggleLists: @_toggleLists
        onAdd: @_add
        onUpdate: @_itemUpdated
        onRemove: @_itemRemoved
        onClearCompleted: @_clearCompleted
      ActionSheet @state.actionSheetProps

  _toggleLists: ->
    if @state.showItems
      @_showLists()
    else
      @_showItems @state.selectedListId

  _showItems: (id)->
    @setState
      showItems: true
      selectedListId: id

  _showLists: ->
    @setState showItems: false

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

  _itemUpdated: (itemId, item)->
    itemRef = @firebaseRefs.lists.child "#{@state.selectedListId}/items/#{itemId}"
    itemRef.update item

  _itemRemoved: (itemId)->
    itemRef = @firebaseRefs.lists.child "#{@state.selectedListId}/items/#{itemId}"
    itemRef.remove()

  _clearCompleted: ->
    actionSheetProps =
      confirmMessage: 'Clear Completed'
      onConfirm: =>
        for id, item of @state.lists[@state.selectedListId].items
          @_itemRemoved id if item.isChecked
        @_removeActionSheet()
      onCancel: =>
        @_removeActionSheet()

    @setState {actionSheetProps}

  _removeActionSheet: ->
    @setState actionSheetProps: null
