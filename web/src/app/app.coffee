React = require 'react'
Loading = require '../loading/loading'
Lists = require '../lists/lists'
Items = require '../items/items'
Login = require '../login/login'

module.exports = React.createClass

  getInitialState: ->
    list: null

  render: ->
    [items, className] = if @state.list?
      [
        Items list: @state.list, onBack: @_showLists
        'app showing-items'
      ]
    else
      [null, 'app']

    React.DOM.div className: className,
      # React.DOM.button onClick: @props.onLogout, 'Logout'
      Lists onListSelect: @_showItems
      items

  _showItems: (list)->
    @setState {list}

  _showLists: ->
    @setState list: null
