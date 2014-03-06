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
    expect(@app.use).to.have.been.calledWith 'json'

  it 'uses express urlencoded', ->
    expect(@app.use).to.have.been.calledWith 'urlencoded'

  it 'uses express cookieParser', ->
    expect(@app.use).to.have.been.calledWith 'cookieParser'

  it 'uses express methodOverride', ->
    expect(@app.use).to.have.been.calledWith 'methodOverride'

  it 'uses express session', ->
    expect(@app.use).to.have.been.calledWith 'session'

  it 'uses app router', ->
    expect(@app.use).to.have.been.calledWith 'router'

  it 'uses express static', ->
    expect(@app.use).to.have.been.calledWith 'static'

