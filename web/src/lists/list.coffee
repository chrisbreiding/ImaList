React = require 'react/addons'

RD = React.DOM
cs = React.addons.classSet

module.exports = React.createClass

  getInitialState: ->
    editing: false
    showingOptions: false

  render: ->
    name = if @state.editing
      RD.input
        ref: 'name'
        className: 'name'
        defaultValue: @props.model.name
        onChange: @_updateName
        onKeyUp: @_keyup
    else
      RD.span
        className: 'name'
        onClick: @props.onSelect
        @props.model.name

    RD.li
      className: cs
        'showing-options': @state.showingOptions
      name
      RD.button
        className: 'toggle-options', onClick: @_toggleOptions
        RD.i className: 'fa fa-ellipsis-h'
      RD.ul
        className: 'options'
        RD.button
          className: 'remove'
          onClick: @_remove
          RD.i className: 'fa fa-times'

  _toggleOptions: ->
    show = !@state.showingOptions
    @setState showingOptions: show, =>
      @_toggleEditing show

  _toggleEditing: (edit)->
    @setState editing: edit

  _remove: ->
    @props.onRemove()

  _updateName: ->
    @props.model.name = @refs.name.getDOMNode().value
    @props.onUpdate @props.model

  _keyup: (e)->
    @_toggleOptions() if e.key is 'Enter'

  edit: ->
    @_toggleOptions()
