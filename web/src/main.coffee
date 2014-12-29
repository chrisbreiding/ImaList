React = require 'react/addons'
RSVP = require 'rsvp'
attachFastClick = require 'fastclick'
App = React.createFactory require './app/app'
Login = React.createFactory require './login/login'
Auth = require './login/auth'

attachFastClick document.body

FIREBASE_URL = 'https://imalist.firebaseio.com'

RSVP.on 'error', (e)->
  console.error 'Error caught by RSVP:'
  console.error e.message
  console.error e.stack

ref = new Firebase FIREBASE_URL
auth = new Auth ref

logout = ->
  auth.logout()
  render()

render = (userEmail)->
  component = if auth.isAuthenticated()
    App firebaseRef: ref, onLogout: logout, userEmail: userEmail ? auth.userEmail()
  else
    Login auth: auth, onLogin: render

  React.render component, document.body

auth.onAuthChange render

render()
