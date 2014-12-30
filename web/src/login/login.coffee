React = require 'react/addons'
Firebase = require 'firebase'

RD = React.DOM

module.exports = React.createClass

  getInitialState: ->
    attemptingLogin: false
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
          if @state.attemptingLogin
            RD.span null, RD.i className: 'fa fa-spinner fa-spin'
          else
            RD.button null, 'Log In'

  _attemptLogin: (e)->
    e.preventDefault()

    email = @refs.email.getDOMNode().value
    password = @refs.password.getDOMNode().value

    @setState attemptingLogin: true, =>
      @props.auth.login(email, password).then (didSucceed)=>
        if didSucceed
          @props.onLogin email
        else
          @setState
            attemptingLogin: false
            loginFailed: true
