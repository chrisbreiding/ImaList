React = require 'react/addons'

RD = React.DOM
Transition = React.addons.CSSTransitionGroup

module.exports = React.createClass

  render: ->
    Transition
      transitionName: 'action-sheet'
      if @props.onConfirm
        RD.div
          ref: 'root', className: 'action-sheet'
          RD.div
            className: 'container'
            RD.button
              className: 'confirm', onClick: @props.onConfirm
              @props.confirmMessage or 'Confirm'
            RD.button
              className: 'cancel', onClick: @props.onCancel
              @props.cancelMessage or 'Cancel'
      else
        null
