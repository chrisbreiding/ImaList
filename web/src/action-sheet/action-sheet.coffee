React = require 'react/addons'
_ = require 'lodash'

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
              className: 'confirm', onClick: _.partial @_close, @props.onConfirm
              @props.confirmMessage or 'Confirm'
            RD.button
              className: 'cancel', onClick: _.partial @_close, @props.onCancel
              @props.cancelMessage or 'Cancel'
      else
        null

  # componentDidUpdate: ->
  #   setTimeout =>
  #     @refs.root?.getDOMNode().className = if @props.onConfirm then 'action-sheet show' else 'action-sheet'

  _close: (andThen)->
    andThen()
    # @refs.root.getDOMNode().className = 'action-sheet'
    # setTimeout andThen, 250
