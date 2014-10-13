React = require 'react'
Loading = require '../loading/loading'
Lists = require '../lists/lists'
Login = require '../login/login'

module.exports = React.createClass

  render: ->
    React.DOM.div null,
      React.DOM.button onClick: @props.onLogout, 'Logout'
      Lists()
