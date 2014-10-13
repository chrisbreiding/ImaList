React = require 'react'
Firebase = require 'firebase'
ReactFireMixin = require 'reactfire'


module.exports = React.createClass

  mixins: [ReactFireMixin]

  # componentWillMount: ->
  #   @bindAsArray new Firebase('https://imalist.firebaseio.com/lists/'), 'lists'

  render: ->
    React.DOM.h1 null, 'lists'

  componentWillUnmount: ->
    # @firebaseRef.off()
