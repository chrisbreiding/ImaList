React = require 'react'
_ = require 'lodash'

RD = React.DOM

module.exports = React.createClass

  getInitialState: ->
    showingOptions: false

  render: ->
    className = ''
    if @props.model.isChecked
      className = 'checked'
    if @state.showingOptions
      className += ' showing-options'
    RD.li
      ref: 'root', className: className
      RD.button
        ref: 'toggleChecked'
        className: 'toggle-checked', onClick: @_toggleChecked
        RD.i className: 'fa fa-check'
      RD.input
        ref: 'name'
        className: 'name'
        defaultValue: @props.model.name
        onChange: @_updateName
      RD.button
        className: 'toggle-options', onClick: @_toggleOptions
        RD.i className: 'fa fa-ellipsis-h'
      RD.ul
        className: 'options'
        RD.button
          onClick: @_remove
          RD.i className: 'fa fa-times'

  edit: ->
    @refs.name.getDOMNode().focus()

  _toggleChecked: ->
    @refs.toggleChecked.getDOMNode().blur()
    @props.model.toggleChecked()
    @props.onUpdate @props.model

  _updateName: _.debounce ->
    @props.model.name = @refs.name.getDOMNode().value
    @props.onUpdate @props.model
  , 500

  _toggleOptions: ->
    @setState showingOptions: !@state.showingOptions

  _remove: ->
    @props.onRemove()
