React = require 'react'
_ = require 'lodash'

RD = React.DOM

module.exports = React.createClass

  render: ->
    return null unless @props.onConfirm

    RD.div
      ref: 'root', className: 'action-sheet'
      RD.div
        className: 'container'
        RD.button
          className: 'confirm', onClick: _.partial @_close, @props.onConfirm
          @props.confirmMessage or 'Confirm'
        RD.button
          className: 'cancel', onClick: _.partial @_close, @props.onCancel
          @props.cancelMessage or 'Cancel'

  componentDidUpdate: ->
    setTimeout =>
      @refs.root.getDOMNode().className = if @props.onConfirm then 'action-sheet show' else 'action-sheet'

  _close: (andThen)->
    @refs.root.getDOMNode().className = 'action-sheet'
    setTimeout andThen, 250
