expect = require('chai').expect
{spy} = require 'sinon'

routes = require '../src/routes'

describe 'routes', ->

  beforeEach ->
    @app = get: spy()
    routes.configure @app

  describe 'get /', ->

    beforeEach ->
      @getRootPath = @app.get.args[0][0]
      getRootCallback = @app.get.args[0][1]

      @res = sendfile: spy()
      getRootCallback null, @res

    it 'gets /', ->
      expect(@getRootPath).to.equal '/'

    it 'sends index.html', ->
      expect(@res.sendfile.calledWithMatch /index\.html/).to.be.true
