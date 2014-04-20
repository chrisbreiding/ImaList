path = require 'path'
_ = require 'lodash'
bodyParser = require 'body-parser'
routes = require './routes'

module.exports = (express, port)->
  app = express()

  app.use bodyParser()
  routes.configure app
  app.use express.static path.join(__dirname, '..', '..', 'client', 'public')

  app.listen port, ->
    console.log "listening on port #{port}..."
