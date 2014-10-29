React = require 'react/addons'
_ = require 'lodash'

RD = React.DOM
cs = React.addons.classSet

module.exports = React.createClass

  getInitialState: ->
    showingOptions: false

  render: ->
    RD.li
      ref: 'root'
      className: cs
        'checked': @props.model.isChecked
        'showing-options': @state.showingOptions
      RD.button
        ref: 'toggleChecked'
        className: 'toggle-checked', onClick: @_toggleChecked
        RD.i className: 'fa fa-check'
      RD.input
        ref: 'name'
        className: 'name'
        defaultValue: @props.model.name
        onChange: @_updateName
        onKeyUp: @_keyup
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

  _keyup: (e)->
    if e.key is 'Enter' and (@refs.name.getDOMNode().value or '').trim() isnt ''
      @props.onNext()

  _toggleOptions: ->
    @setState showingOptions: !@state.showingOptions

  _remove: ->
    @props.onRemove()
