React = require 'react'
_ = require 'lodash'
Firebase = require 'firebase'
ReactFireMixin = require 'reactfire'

RD = React.DOM

module.exports = React.createClass

  mixins: [ReactFireMixin]

  getInitialState: ->
    lists: []

  componentWillMount: ->
    @bindAsObject new Firebase('https://imalist.firebaseio.com/lists/'), 'lists'

  render: ->
    lists = _.map @state.lists, (list, id)=>
      RD.li
        key: list.name, onClick: @_didSelectList(id)
        list.name
    RD.div className: 'lists',
      RD.ul null, lists

  _didSelectList: (listId)->
    => @props.onListSelect listId
