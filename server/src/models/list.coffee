mongoose = require 'mongoose'
_ = require 'lodash'

listSchema = mongoose.Schema
  name: String
  owner: String
  viewers: [{ user: String, order: Number }]
  items: [{
    name: String
    completed: Boolean
    priority: String
  }]

listSchema.methods.projection = (user)->
  _id: @_id
  name: @name
  isOwner: @owner is user.id
  order: _.find(@viewers, user: user.id).order
  items: @items

listSchema.statics.projectionsForUser = (user, cb)->
  @find { viewers: $elemMatch: { user: user.id } }, (err, lists)->
    cb err, _.map(lists, (list)-> list.projection(user))

module.exports = mongoose.model 'List', listSchema
