React = require 'react/addons'

Name = React.createFactory require './name'

RD = React.DOM
cs = React.addons.classSet

module.exports = React.createClass
  displayName: 'Item'

  getInitialState: ->
    showingOptions: false
    editing: false

  render: ->
    RD.li
      className: cs
        'item': true
        'checked': @props.model.isChecked
        'editing': @state.editing
        'showing-options': @state.showingOptions
      'data-id': @props.id
      RD.button
        ref: 'toggleChecked'
        className: 'toggle-checked', onClick: @_toggleChecked
        RD.i className: 'fa fa-check'
      RD.i className: 'sort-handle fa fa-arrows'
      Name
        ref: 'name'
        name: @props.model.name
        editing: @state.editing
        onEditingStatusChange: @_onEditingStatusChange
        onUpdate: @_updateName
        onNext: @props.onNext
      RD.button
        className: 'next', onClick: @_nextIfValue
        RD.i className: 'fa fa-level-down'
      RD.div
        className: 'options'
        RD.button
          className: 'toggle-options', onClick: @_toggleOptions
          RD.i className: 'fa fa-ellipsis-h'
        RD.button
          className: 'remove'
          onClick: @_remove
          RD.i className: 'fa fa-times'

  edit: ->
    @setState editing: true, =>
      @refs.name.edit()

  _nextIfValue: ->
    if @refs.name.hasValue()
     @props.onNext()

  _toggleChecked: ->
    @refs.toggleChecked.getDOMNode().blur()
    @props.model.toggleChecked()
    @props.onUpdate @props.model

  _onEditingStatusChange: (editing)->
    @setState
      editing: editing
      showingOptions: false

  _updateName: (name)->
    @props.model.name = name
    @props.onUpdate @props.model

  _toggleOptions: ->
    @setState showingOptions: !@state.showingOptions

  _remove: ->
    @props.onRemove()
