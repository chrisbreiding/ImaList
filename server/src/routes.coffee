path = require 'path'

configure = (app)->

  app.get '/', (req, res)->
    res.sendfile path.join(__dirname, '..', 'client', 'dist', 'index.html')

module.exports = configure: configure
