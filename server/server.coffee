express = require 'express'
path = require 'path'
mongoose = require 'mongoose'
app = express()

mongoose.connect 'mongodb://localhost/imalist_db'

app.configure ->
  app.use express.bodyParser()
  app.use app.router
  app.use express.static(path.join(__dirname, 'client', 'dist'))

app.listen 3000

console.log 'listening on http://localhost:3000...'
