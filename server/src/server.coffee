path = require 'path'
_ = require 'lodash'

express = require 'express'
app = express()

mongoose = require 'mongoose'
User = require './models/user'
List = require './models/list'

mongoose.connect 'localhost', 'imalist_db'

db = mongoose.connection
db.on 'error', console.error.bind(console, 'connection error: ')

publicDir = path.join __dirname, '..', '..', 'client', 'public'

app.configure ->
  app.use express.json()
  app.use express.urlencoded()
  app.use express.cookieParser()
  app.use express.methodOverride()
  app.use express.session(secret: 'xbjgfmh8:w}Zb36FfN.$4Pdpm^C9aJ')
  app.use app.router
  app.use express.static(publicDir)

app.get '/', (req, res)->
  res.sendfile path.join(publicDir, 'index.html')

app.get '/users', (req, res)->
  User.projections (err, users)->
    return res.send(err) if err
    res.send users

app.get '/lists', (req, res)->
  User.findOne { name: 'Sarah' }, (err, user)->
    return res.send(err) if err
    List.projectionsForUser user, (err, lists)->
      return res.send(err) if err
      res.send lists

app.listen 3000, ->
  console.log 'listening on port 3000...'
