React = require 'react'
_ = require 'lodash'
Firebase = require 'firebase'
ReactFireMixin = require 'reactfire'
Lists = require '../lists/lists'
Items = require '../items/items'

RD = React.DOM

module.exports = React.createClass

  mixins: [ReactFireMixin]

  getInitialState: ->
    lists: []
    selectedListId: null

  componentWillMount: ->
    @bindAsObject new Firebase('https://imalist.firebaseio.com/lists/'), 'lists'

  render: ->
    lists = @state.lists

    selectedListId = @state.selectedListId ? Object.keys(lists)[0]
    selectedList = @state.lists[selectedListId] or items: {}

    className = if @state.selectedListId? then 'app showing-items' else 'app'

    RD.div className: className,
      RD.header null,
        RD.h1 null, @state.selectedList?.name or 'ImaList'
        RD.button onClick: @_showLists,
          RD.i className: 'fa fa-chevron-left'
      Lists lists: lists, onListSelect: @_showItems
      Items items: selectedList.items, onUpdate: _.partial @_itemUpdated, selectedListId

  _showItems: (id)->
    @setState selectedListId: id

  _showLists: ->
    @setState selectedListId: null

  _itemUpdated: (listId, itemId, item)->
    itemRef = @firebaseRefs.lists.child "#{listId}/items/#{itemId}"
    itemRef.update item
