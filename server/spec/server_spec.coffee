expect = require('chai').expect
{spy, stub, mock} = require 'sinon'
routes = require '../src/routes'

server = require '../src/server'

describe 'server', ->

  before ->
    spy routes, 'activate'

  after ->
    routes.activate.restore()

  beforeEach ->
    @app = mock()
    @app.configure = spy()
    @app.use = spy()
    @app.get = spy()
    @app.listen = spy()

    @express = stub().returns @app
    @cut = server @express, 1337

  it 'creates a server', ->
    expect(@express.called).to.be.true

  it 'configures app', ->
    expect(@app.configure.called).to.be.true

  it 'activates the routes with app', ->
    expect(routes.activate.calledWith @app).to.be.true

  it 'listens on port specified', ->
    expect(@app.listen.calledWith 1337).to.be.true

  describe 'configuration', ->

    beforeEach ->
      @express.json = stub().returns 'json'
      @express.urlencoded = stub().returns 'urlencoded'
      @express.cookieParser = stub().returns 'cookieParser'
      @express.methodOverride = stub().returns 'methodOverride'
      @express.session = stub().returns 'session'
      @app.router = 'router'
      @express.static = stub().returns 'static'

      configureCallback = @app.configure.args[0][0]
      configureCallback()

    it 'uses express json', ->
      expect(@app.use.calledWith 'json').to.be.true

    it 'uses express urlencoded', ->
      expect(@app.use.calledWith 'urlencoded').to.be.true

    it 'uses express cookieParser', ->
      expect(@app.use.calledWith 'cookieParser').to.be.true

    it 'uses express methodOverride', ->
      expect(@app.use.calledWith 'methodOverride').to.be.true

    it 'uses express session', ->
      expect(@app.use.calledWith 'session').to.be.true

    it 'uses app router', ->
      expect(@app.use.calledWith 'router').to.be.true

    it 'uses express static', ->
      expect(@app.use.calledWith 'static').to.be.true

