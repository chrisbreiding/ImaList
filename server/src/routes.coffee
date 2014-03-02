path = require 'path'

activate = (app)->

  app.get '/', (req, res)->
    res.sendfile path.join(__dirname, '..', 'client', 'dist', 'index.html')

module.exports = activate: activate
