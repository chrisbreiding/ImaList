React = require 'react'

RD = React.DOM

module.exports = React.createClass

  render: ->
    RD.li
      className: if @props.model.isChecked then 'checked' else ''
      RD.button
        ref: 'toggleChecked'
        className: 'toggle-checked', onClick: @_toggleChecked
        RD.i className: 'fa fa-check'
      RD.span
        className: 'name'
        @props.model.name

  _toggleChecked: ->
    @refs.toggleChecked.getDOMNode().blur()
    @props.model.toggleChecked()
    @props.onUpdate @props.model
