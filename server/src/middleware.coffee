path = require 'path'

exports.configure = (express, app)->
  app.use express.json()
  app.use express.urlencoded()
  app.use express.cookieParser()
  app.use express.methodOverride()
  app.use express.session(secret: process.env.SESSION_SECRET)
  app.use app.router
  app.use express.static(path.join __dirname, '..', '..', 'client', 'public')
