path = require 'path'

configure = (express, app)->
  app.use express.json()
  app.use express.urlencoded()
  app.use express.cookieParser()
  app.use express.methodOverride()
  app.use express.session(secret: 'xbjgfmh8:w}Zb36FfN.$4Pdpm^C9aJ')
  app.use app.router
  app.use express.static(path.join __dirname, '..', '..', 'client', 'public')

module.exports = configure: configure
