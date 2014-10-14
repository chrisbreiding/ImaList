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
    selectedList: null

  componentWillMount: ->
    @bindAsObject new Firebase('https://imalist.firebaseio.com/lists/'), 'lists'

  render: ->
    lists = @state.lists

    selectedList = @state.selectedList or lists[Object.keys(lists)[0]] or items: []

    button = @state.selectedList and RD.button onClick: @_showLists,
      RD.i className: 'fa fa-chevron-left'

    className = if @state.selectedList then 'app showing-items' else 'app'

    RD.div className: className,
      RD.header null,
        RD.h1 null, @state.selectedList?.name or 'ImaList'
        button
      Lists lists: lists, onListSelect: @_showItems
      Items items: selectedList.items

  _showItems: (list)->
    @setState selectedList: list

  _showLists: ->
    @setState selectedList: null
