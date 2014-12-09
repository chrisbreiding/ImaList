React = require 'react/addons'

Name = React.createFactory require './name'

RD = React.DOM
cs = React.addons.classSet

module.exports = React.createClass

  getInitialState: ->
    showingOptions: false
    editing: false

  render: ->
    RD.li
      ref: 'root'
      className: cs
        'checked': @props.model.isChecked
        'editing': @state.editing
        'showing-options': @state.showingOptions
      RD.button
        ref: 'toggleChecked'
        className: 'toggle-checked', onClick: @_toggleChecked
        RD.i className: 'fa fa-check'
      Name
        ref: 'name'
        name: @props.model.name
        editing: @state.editing
        onEditingStatusChange: @_onEditingStatusChange
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

  edit: ->
    @setState editing: true, =>
      @refs.name.edit()

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
