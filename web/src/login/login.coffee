React = require 'react'
Firebase = require 'firebase'
auth = require './auth'

RD = React.DOM

module.exports = React.createClass

  render: ->
    RD.div
      className: 'login'
      RD.h1 null, 'Please Log In'
      RD.form
        onSubmit: @_attemptLogin
        RD.fieldset null,
          RD.label null, 'Email'
          RD.input ref: 'email'
        RD.fieldset null,
          RD.label null, 'Password'
          RD.input ref: 'password', type: 'password'
        RD.button null, 'Log In'

  _attemptLogin: (e)->
    e.preventDefault()

    email = @refs.email.getDOMNode().value
    password = @refs.password.getDOMNode().value
    auth.login(email, password).then (didSucceed)=>
      @props.onLogin() if didSucceed
