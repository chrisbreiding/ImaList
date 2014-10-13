Firebase = require 'firebase'
RSVP = require 'rsvp'

module.exports =

  isAuthenticated: ->
    @_getRef().getAuth()?

  onAuthChange: (callback)->
    @_getRef().onAuth callback

  login: (email, password)->
    new RSVP.Promise (resolve)=>
      @_getRef().authWithPassword
        email: email
        password: password
      ,
        (err, authData)->
          resolve authData?

  logout: ->
    @_getRef().unauth()

  _getRef: ->
    @_ref or (@_ref = new Firebase 'https://imalist.firebaseio.com')
