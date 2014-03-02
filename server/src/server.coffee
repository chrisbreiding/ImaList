path = require 'path'
_ = require 'lodash'
routes = require './routes'

module.exports = (express, port)->
  app = express()

  publicDir = path.join __dirname, '..', '..', 'client', 'public'

  app.configure ->
    app.use express.json()
    app.use express.urlencoded()
    app.use express.cookieParser()
    app.use express.methodOverride()
    app.use express.session(secret: 'xbjgfmh8:w}Zb36FfN.$4Pdpm^C9aJ')
    app.use app.router
    app.use express.static(publicDir)

  routes.activate app

  app.listen port, ->
    console.log "listening on port #{port}..."
