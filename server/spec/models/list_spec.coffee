expect = require('chai').expect
{spy, stub} = require 'sinon'
List = require '../../src/models/list'

describe 'List', ->

  beforeEach ->
    @properties =
      name: 'Bob'
      owner: 'user-id'
      viewers: [
        user: 'user-id'
        order: 0
      ,
        user: 'another-user-id'
        order: 2
      ]
      items: [
        name: 'Tofu'
        completed: false
        priority: 'normal'
      ,
        name: 'Celery'
        completed: true
        priority: 'urgent'
      ]
    @cut = new List @properties

  it 'exists', ->
    expect(@cut).not.to.be.null

  describe 'projection', ->

    beforeEach ->
      @properties._id = 'some-id'
      @result = @cut.projection.call @properties, id: 'user-id'

    it 'passes through the _id', ->
      expect(@result._id).to.equal 'some-id'

    it 'passes through the name', ->
      expect(@result.name).to.equal 'Bob'

    it 'reports if user is the owner', ->
      expect(@result.isOwner).to.be.true

    it 'reports order for user', ->
      expect(@result.order).to.equal 0

    it 'passes through the items', ->
      expect(@result.items).to.equal @properties.items

  describe 'projections for user', ->

    beforeEach ->
      @find = spy()
      @user = id: 'user-id'
      @projectionsCallback = spy()
      List.projectionsForUser.call { find: @find }, @user, @projectionsCallback
      @callback = @find.args[0][1]

    it 'queries with find', ->
      expect(@find.called).to.be.true

    it 'queries for viewers who match user', ->
      query = @find.args[0][0]
      expect(query).to.be.an 'object'
      expect(query.viewers.$elemMatch.user).to.equal 'user-id'

    it 'passes callback to find', ->
      expect(@callback).to.be.a 'function'

    describe 'when lists are returned', ->

      beforeEach ->
        @listProjection = stub()
        @listProjection.onCall(0).returns 'projection 1'
        list1 = projection: @listProjection
        @listProjection.onCall(1).returns 'projection 2'
        list2 = projection: @listProjection

        @callback null, [list1, list2]

      it 'passes in the user to each projection', ->
        user1 = @listProjection.args[0][0]
        expect(user1).to.equal @user
        user2 = @listProjection.args[1][0]
        expect(user2).to.equal @user

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
