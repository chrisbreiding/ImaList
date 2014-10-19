React = require 'react'
_ = require 'lodash'

RD = React.DOM

module.exports = React.createClass

  render: ->
    RD.li
      className: if @props.model.isChecked then 'checked' else ''
      RD.button
        ref: 'toggleChecked'
        className: 'toggle-checked', onClick: @_toggleChecked
        RD.i className: 'fa fa-check'
      RD.input
        ref: 'name'
        className: 'name'
        defaultValue: @props.model.name
        onChange: @_updateName

  _toggleChecked: ->
    @refs.toggleChecked.getDOMNode().blur()
    @props.model.toggleChecked()
    @props.onUpdate @props.model

  _updateName: _.debounce ->
    @props.model.name = @refs.name.getDOMNode().value
    @props.onUpdate @props.model
  , 500

  edit: ->
    @refs.name.getDOMNode().focus()
