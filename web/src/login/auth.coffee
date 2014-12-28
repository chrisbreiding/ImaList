Firebase = require 'firebase'
RSVP = require 'rsvp'

module.exports = class Auth

  constructor: (@_ref)->

  isAuthenticated: ->
    @_ref.getAuth()?

  userEmail: ->
    @_ref.getAuth().password.email

  onAuthChange: (callback)->
    @_ref.onAuth callback

  login: (email, password)->
    new RSVP.Promise (resolve)=>
      @_ref.authWithPassword
        email: email
        password: password
      ,
        (err, authData)->
          resolve authData?

  logout: ->
    @_ref.unauth()
