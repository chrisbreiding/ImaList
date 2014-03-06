path = require 'path'
_ = require 'lodash'
middleware = require './middleware'
routes = require './routes'

module.exports = (express, port)->
  app = express()

  middleware.configure express, app
  routes.configure app

  app.listen port, ->
    console.log "listening on port #{port}..."
