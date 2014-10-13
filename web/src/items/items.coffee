React = require 'react'
_ = require 'lodash'
Firebase = require 'firebase'
ReactFireMixin = require 'reactfire'

RD = React.DOM

module.exports = React.createClass

  mixins: [ReactFireMixin]

  getInitialState: ->
    items: []

  componentWillMount: ->
    @bindAsObject new Firebase("https://imalist.firebaseio.com/lists/#{@props.listId}/items/"), 'items'

  render: ->
    items = _.map @state.items, (list)->
      RD.li key: list.name, list.name
    RD.div className: 'items',
      RD.button onClick: @props.onBack, 'Back'
      RD.ul null, items
