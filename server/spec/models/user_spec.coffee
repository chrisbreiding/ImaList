expect = require('chai').expect
{spy, stub} = require 'sinon'
User = require '../../src/models/user'

describe 'User', ->

  beforeEach ->
    @properties =
      name: 'Bob'
      username: 'bob'
      password: 'secret'

    @cut = new User @properties

  it 'exists', ->
    expect(@cut).not.to.be.null

  describe 'projection', ->

    beforeEach ->
      @properties._id = 'some-id'
      @result = @cut.projection.call @properties

    it 'passes through the _id', ->
      expect(@result._id).to.equal 'some-id'

    it 'passes through the name', ->
      expect(@result.name).to.equal 'Bob'

    it 'passes through the username', ->
      expect(@result.username).to.equal 'bob'

    it 'does not pass through the password', ->
      expect(@result.password).to.be.undefined

  describe 'projections', ->

    beforeEach ->
      @find = spy()
      @projectionsCallback = spy()
      User.projections.call { find: @find }, @projectionsCallback
      @callback = @find.args[0][0]

    it 'does a find for all users', ->
      expect(@find.called).to.be.true

    it 'passes callback to find', ->
      expect(@callback).to.be.a 'function'

    describe 'when users are returned', ->

      beforeEach ->
        @userProjection = stub()
        @userProjection.onCall(0).returns 'projection 1'
        user1 = projection: @userProjection
        @userProjection.onCall(1).returns 'projection 2'
        user2 = projection: @userProjection

        @callback null, [user1, user2]

      it 'calls the projections callback', ->
        expect(@projectionsCallback.called).to.be.true

      it 'passes array of list projections to projectionsCallback', ->
        lists = @projectionsCallback.args[0][1]
        expect(lists).to.eql ['projection 1', 'projection 2']

    describe 'when there is an error', ->

      beforeEach ->
        @callback 'some error'

      it 'calls the projections callback', ->
        expect(@projectionsCallback.called).to.be.true

      it 'passes through the error', ->
        err = @projectionsCallback.args[0][0]
        expect(err).to.equal 'some error'
