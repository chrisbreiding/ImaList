{spy, stub} = sinon

middleware = require '../src/middleware'

describe 'middleware', ->

  beforeEach ->
    @express =
      json: stub().returns 'json'
      urlencoded: stub().returns 'urlencoded'
      cookieParser: stub().returns 'cookieParser'
      methodOverride: stub().returns 'methodOverride'
      session: stub().returns 'session'
      static: stub().returns 'static'
    @app =
      use: spy()
      router: 'router'

    middleware.configure @express, @app

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

