React = require 'react/addons'
_ = require 'lodash'

Name = React.createFactory require './name'

RD = React.DOM
cs = React.addons.classSet

module.exports = React.createClass

  getInitialState: ->
    showingOptions: false
    editing: false
    multiline: false

  render: ->
    isMultiline = @state.multiline or (@_nameHasMultipleLines() and @state.editing)
    multilineIcon = if isMultiline then 'minus' else 'bars'

    RD.li
      ref: 'root'
      className: cs
        'checked': @props.model.isChecked
        'editing': @state.editing
        'multiline': isMultiline
        'showing-options': @state.showingOptions
      RD.button
        ref: 'toggleChecked'
        className: 'toggle-checked', onClick: @_toggleChecked
        RD.i className: 'fa fa-check'
      Name
        ref: 'name'
        name: @props.model.name
        multiline: isMultiline
        editing: @state.editing
        onEdit: @_onEdit
        onUpdate: @_updateName
        onNext: @props.onNext
      RD.button
        className: 'toggle-options', onClick: @_toggleOptions
        RD.i className: 'fa fa-ellipsis-h'
      RD.ul
        className: 'options'
        RD.button
          className: 'remove'
          onClick: @_remove
          RD.i className: 'fa fa-times'
      RD.button
        className: 'toggle-multiline', onClick: @_toggleMultiline
        RD.i className: "fa fa-#{multilineIcon}"

  edit: ->
    @refs.name.edit()

  stopEditing: ->
    @setState
      editing: false
      multiline: false

  _nameHasMultipleLines: ->
    _.contains @props.model.name, '\n'

  _toggleChecked: ->
    @refs.toggleChecked.getDOMNode().blur()
    @props.model.toggleChecked()
    @props.onUpdate @props.model

  _onEdit: ->
    @props.onEdit()
    @setState editing: true

  _updateName: (name)->
    @props.model.name = name
    @props.onUpdate @props.model

  _toggleOptions: ->
    @setState showingOptions: !@state.showingOptions

  _remove: ->
    @props.onRemove()

  _toggleMultiline: (e)->
    e.stopPropagation()
    @setState multiline: !@state.multiline, =>
      @edit()
