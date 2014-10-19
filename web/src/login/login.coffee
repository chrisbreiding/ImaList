React = require 'react'
Firebase = require 'firebase'
auth = require './auth'

RD = React.DOM

module.exports = React.createClass

  getInitialState: ->
    loginFailed: false

  render: ->
    RD.div
      className: 'login'
      RD.header null,
        RD.h1 null, 'Please Log In'
      if @state.loginFailed then RD.p className: 'error', 'Login failed. Please try again.' else null
      RD.form
        onSubmit: @_attemptLogin
        RD.fieldset null,
          RD.label null, 'Email'
          RD.input ref: 'email', type: 'email'
        RD.fieldset null,
          RD.label null, 'Password'
          RD.input ref: 'password', type: 'password'
        RD.fieldset null,
          RD.button null, 'Log In'

  _attemptLogin: (e)->
    e.preventDefault()

    email = @refs.email.getDOMNode().value
    password = @refs.password.getDOMNode().value
    auth.login(email, password).then (didSucceed)=>
      if didSucceed
        @props.onLogin()
      else
        @setState loginFailed: true
