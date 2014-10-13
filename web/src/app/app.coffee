React = require 'react'
Loading = require '../loading/loading'
Lists = require '../lists/lists'
Items = require '../items/items'
Login = require '../login/login'

module.exports = React.createClass

  getInitialState: ->
    listId: null

  render: ->
    items = if @state.listId?
      Items listId: @state.listId, onBack: @_showLists
    else
      null

    React.DOM.div null,
      React.DOM.button onClick: @props.onLogout, 'Logout'
      Lists onListSelect: @_showItems
      items

  _showItems: (listId)->
    @setState listId: listId

  _showLists: ->
    @setState listId: null
