mongoose = require 'mongoose'
_ = require 'lodash'

userSchema = mongoose.Schema
  name: type: String, require: true
  username: type: String, require: true, unique: true
  password: type: String, require: true
  accessToken: String

userSchema.methods.projection = ->
  _id: @_id
  name: @name
  username: @username

userSchema.statics.projections = (cb)->
  @find (err, users)->
    cb err, _.map(users, (user)-> user.projection())

module.exports = mongoose.model 'User', userSchema
