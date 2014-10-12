thinky = require('thinky')()

Item = thinky.createModel 'Item',
  id: String
  name: String
  completed: _type: Boolean, default: false
  listId: String

List = thinky.createModel 'List',
  id: String
  name: String
  userId: String

User = thinky.createModel 'User',
  id: String
  username: String
  password: String

Item.belongsTo List, 'list', 'listId', 'id'
List.hasMany Item, 'items', 'id', 'listId'

List.belongsTo User, 'user', 'userId', 'id'
User.hasMany List, 'lists', 'id', 'ownerId'

List.ensureIndex 'userId'

module.exports =

  addUser: (data)->
    (new User data).saveAll()

  getUsers: ->
    User.run()

  getUser: (id)->
    User.get(id).getJoin().run()

  addList: (data)->
    (new List data).saveAll()

  getLists: (userId)->
    User.get(userId).getJoin().run().then (user)->
      user.lists

  getList: (id)->
    List.get(id).getJoin().run()
