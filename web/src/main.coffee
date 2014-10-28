React = require 'react/addons'
RSVP = require 'rsvp'
attachFastClick = require 'fastclick'
App = React.createFactory require './app/app'
Login = React.createFactory require './login/login'
auth = require './login/auth'

attachFastClick document.body

RSVP.on 'error', (e)->
  console.error 'Error caught by RSVP:'
  console.error e.message
  console.error e.stack

logout = ->
  auth.logout()
  render()

render = ->
  component = if auth.isAuthenticated()
    App onLogout: logout
  else
    Login onLogin: render

  React.render component, document.body

auth.onAuthChange render
render()
