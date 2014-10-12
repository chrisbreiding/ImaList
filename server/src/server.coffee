path = require 'path'
bodyParser = require 'body-parser'
setupRoutes = require './routes'

module.exports = (express, port)->
  app = express()

  app.use bodyParser()
  setupRoutes app
  app.use express.static path.join(__dirname, '..', '..', 'client', 'public')

  app.listen port, ->
    console.log "listening on port #{port}..."
