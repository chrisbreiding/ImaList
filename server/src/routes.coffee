db = require './db'

module.exports = (app)->

  app.get '/api/lists', (req, res)->
    return res.send(400, 'must specify userId for lists') unless req.query.userId

    db.getLists(req.query.userId).then (lists)->
      res.json lists

    # db.getUser('b33d4ed6-7dd6-4d1a-b974-996152e24179').then (user)->
    #   res.json user

    # addUser = db.addUser
    #   username: 'chris'
    #   password: 'foo'
    #   lists: [
    #     name: 'list 1'
    #     items: [
    #       name: 'item 1'
    #     ,
    #       name: 'item 2'
    #     ,
    #       name: 'item 3'
    #     ,
    #       name: 'item 4'
    #     ]
    #   ,
    #     name: 'list 2'
    #     items: [
    #       name: 'item 5'
    #     ,
    #       name: 'item 6'
    #     ,
    #       name: 'item 7'
    #     ,
    #       name: 'item 8'
    #     ]
    #   ]

    # addUser.then (user)->
    #   res.json user
