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
    @bindAsObject new Firebase("https://imalist.firebaseio.com/lists/#{@props.list.id}/items/"), 'items'

  render: ->
    items = _.map @state.items, (item)->
      RD.li
        key: item.name
        item.name
    RD.div className: 'items',
      RD.header null,
        RD.h1 null, @props.list.name
        RD.button onClick: @props.onBack,
          RD.i className: 'fa fa-chevron-left'
      RD.ul null, items
