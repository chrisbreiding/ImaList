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
        'list': true
        'showing-options': @state.showingOptions
        'shared': @props.model.shared
        'is-owner': @props.isOwner
        'is-selected': @props.isSelected
      'data-id': @props.id
      RD.i className: 'sort-handle fa fa-arrows'
      name
      RD.div
        className: 'options'
        RD.i className: 'shared-indicator fa fa-share-alt-square'
        RD.button
          className: 'toggle-options', onClick: @_toggleOptions
          RD.i className: 'fa fa-ellipsis-h'
        RD.button
          className: 'toggle-shared'
          onClick: @_toggledShared
          RD.i className: 'fa fa-share-alt'
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

  _toggledShared: ->
    @props.model.shared = !@props.model.shared
    @_update()

  _remove: ->
    @props.onRemove()

  _updateName: ->
    @props.model.name = @refs.name.getDOMNode().value
    @_update()

  _update: ->
    @props.onUpdate @props.model

  _keyup: (e)->
    @_toggleOptions() if e.key is 'Enter'

  edit: ->
    @_toggleOptions()
