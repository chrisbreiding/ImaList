r = require 'rethinkdb'
_ = require 'lodash'

config =
  host: process.env.DB_HOST or 'localhost'
  port: parseInt(process.env.DB_PORT) or 28015
  db: process.env.DB_DB or 'imalist'
  tables: ['lists', 'items', 'users']

module.exports =

  setup: ->
    r.connect { host: config.host, port: config.port }, (err, connection)->
      throw err if err
      r.dbCreate(config.db).run connection, ->
        _.each config.tables, (tableName)->
          r.db(config.db).tableCreate tableName, primaryKey: tableName
