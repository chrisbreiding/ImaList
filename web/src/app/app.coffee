React = require 'react/addons'
_ = require 'lodash'
Firebase = require 'firebase'
ReactFireMixin = require 'reactfire'
Lists = React.createFactory require '../lists/lists'
Items = React.createFactory require '../items/items'
ItemModel = require '../items/item-model'
ListModel = require '../lists/list-model'
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
    @bindAsObject @props.firebaseRef.child('lists'), 'lists'

  componentDidUpdate: ->
    store.save
      selectedListId: @state.selectedListId
      showItems: @state.showItems

  render: ->
    lists = @state.lists

    userSelectedId = @state.selectedListId ? null

    fallbackId = Object.keys(lists)[0]
    selectedListId = userSelectedId ? fallbackId

    selectedList = if @state.lists[selectedListId]
      @state.lists[selectedListId]
    else if @state.lists[fallbackId]
      selectedListId = fallbackId
      @state.lists[fallbackId]
    else
      selectedListId = null
      items: {}

    RD.div
      className: cs
        'app': true
        'showing-items': @state.showItems
      Lists
        ref: 'lists'
        lists: lists
        selectedListId: selectedListId
        userEmail: @props.userEmail
        onLogout: @_logout
        onAdd: @_addList
        onListSelect: @_showItems
        onUpdate: @_listUpdated
        onRemove: @_listRemoved
      Items
        ref: 'items'
        listName: selectedList.name
        items: selectedList.items
        onShowLists: @_showLists
        onAdd: @_addItem
        onUpdate: @_itemUpdated
        onRemove: @_itemRemoved
        onClearCompleted: @_clearCompleted
      ActionSheet @state.actionSheetProps

  _logout: ->
    actionSheetProps =
      confirmMessage: 'Logout'
      onConfirm: =>
        @_removeActionSheet =>
          @props.onLogout()
      onCancel: =>
        @_removeActionSheet()

    @setState {actionSheetProps}

  _showItems: (id)->
    @setState
      showItems: true
      selectedListId: id

  _showLists: ->
    @setState showItems: false

  _add: (type, ref, items, Model)->
    unless Object.keys(items).length
      @_addWithOrder type, ref, Model, 0
      return

    order = @_lastOrder(items) + 1
    @_addWithOrder type, ref, Model, order

  _lastOrder: (items)->
    Math.max _.pluck(items, 'order')...

  _addWithOrder: (type, ref, Model, order)->
    newRef = ref.push Model.newOne(order, @props.userEmail), =>
      @refs[type].edit newRef.key()

  _addList: ->
    @_add 'lists', @firebaseRefs.lists, @state.lists, ListModel

  _listUpdated: (id, list)->
    @firebaseRefs.lists.child(id).update list

  _listRemoved: (id)->
    actionSheetProps =
      confirmMessage: 'Remove List'
      onConfirm: =>
        @firebaseRefs.lists.child(id).remove()
        @_removeActionSheet()
      onCancel: =>
        @_removeActionSheet()

    @setState {actionSheetProps}

  _addItem: ->
    ref = @firebaseRefs.lists.child "#{@state.selectedListId}/items/"
    items = @state.lists[@state.selectedListId].items or {}
    @_add 'items', ref, items, ItemModel

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

  _removeActionSheet: (callback)->
    @setState actionSheetProps: null, callback
