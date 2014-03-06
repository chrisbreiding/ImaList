{spy, stub} = sinon

middleware = require '../src/middleware'
routes = require '../src/routes'

server = require '../src/server'

describe 'server', ->

  before ->
    stub middleware, 'configure'
    stub routes, 'configure'

  beforeEach ->
    @app = listen: spy()
    @express = stub().returns @app

    server @express, 1337

  it 'creates a server', ->
    expect(@express.called).to.be.true

  it 'configures middleware with express and app', ->
    expect(middleware.configure.calledWith @express, @app).to.be.true

  it 'configures routes with app', ->
    expect(routes.configure.calledWith @app).to.be.true

  it 'listens on port specified', ->
    expect(@app.listen.calledWith 1337).to.be.true
