React = require 'react/addons'
_ = require 'lodash'
Firebase = require 'firebase'
ReactFireMixin = require 'reactfire'
Lists = React.createFactory require '../lists/lists'
Items = React.createFactory require '../items/items'
ItemModel = require '../items/item-model'
ActionSheet = React.createFactory require '../action-sheet/action-sheet'
store = require '../lib/store'

RD = React.DOM
cs = React.addons.classSet

module.exports = React.createClass

  mixins: [ReactFireMixin]

  getInitialState: ->
    lists: []
    showItems: store.fetch('showItems') or false
    selectedListId: store.fetch('selectedListId') ? null

  componentWillMount: ->
    @bindAsObject new Firebase('https://imalist.firebaseio.com/lists/'), 'lists'

  componentDidUpdate: ->
    store.save
      selectedListId: @state.selectedListId
      showItems: @state.showItems

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
        onUpdate: @_listUpdated
        onRemove: @_listRemoved
      Items
        ref: 'items'
        listName: selectedList.name
        items: selectedList.items
        onShowLists: @_showLists
        onAdd: @_add
        onUpdate: @_itemUpdated
        onRemove: @_itemRemoved
        onClearCompleted: @_clearCompleted
      ActionSheet @state.actionSheetProps

  _showItems: (id)->
    @setState
      showItems: true
      selectedListId: id

  _showLists: ->
    @setState showItems: false

  _listUpdated: (id, list)->
    @firebaseRefs.lists.child(id).update list

  _listRemoved: (id)->
    @firebaseRefs.lists.child(id).remove()

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
      @refs.items.editItem newItemRef.name()

  _itemUpdated: (id, item)->
    itemRef = @firebaseRefs.lists.child "#{@state.selectedListId}/items/#{id}"
    itemRef.update item

  _itemRemoved: (id)->
    itemRef = @firebaseRefs.lists.child "#{@state.selectedListId}/items/#{id}"
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
