React = require 'react'
RSVP = require 'rsvp'
App = require './app/app'
Login = require './login/login'
auth = require './login/auth'

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

  React.renderComponent component, document.body

auth.onAuthChange render
render()
