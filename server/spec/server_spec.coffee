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
    expect(@express).to.have.been.called

  it 'configures middleware with express and app', ->
    expect(middleware.configure).to.have.been.calledWith @express, @app

  it 'configures routes with app', ->
    expect(routes.configure).to.have.been.calledWith @app

  it 'listens on port specified', ->
    expect(@app.listen).to.have.been.calledWith 1337
