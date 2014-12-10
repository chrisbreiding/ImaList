React = require 'react/addons'

RD = React.DOM
cs = React.addons.classSet

module.exports = React.createClass

  render: ->
    if @props.confirmMessage
      @previousConfirm = @props.confirmMessage
    if @props.cancelMessage
      @previousCancel = @props.cancelMessage

    RD.div
      className: cs
        'action-sheet': true
        'action-sheet-showing': @props.onConfirm?
      RD.div
        className: 'container'
        RD.button
          className: 'confirm', onClick: @props.onConfirm
          @props.confirmMessage or @previousConfirm or 'Confirm'
        RD.button
          className: 'cancel', onClick: @props.onCancel
          @props.cancelMessage or @previousCancel or 'Cancel'
