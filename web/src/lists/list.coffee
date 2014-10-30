React = require 'react/addons'

RD = React.DOM
cs = React.addons.classSet

module.exports = React.createClass

  getInitialState: ->
    showingOptions: false

  render: ->
    RD.li
      className: cs
        'showing-options': @state.showingOptions
      RD.span
        className: 'name'
        onClick: @props.onSelect
        @props.name
      RD.button
        className: 'toggle-options', onClick: @_toggleOptions
        RD.i className: 'fa fa-ellipsis-h'
      RD.ul
        className: 'options'
        RD.button
          className: 'edit'
          onClick: @_edit
          RD.i className: 'fa fa-edit'
        RD.button
          className: 'remove'
          onClick: @_remove
          RD.i className: 'fa fa-times'

  _toggleOptions: ->
    @setState showingOptions: !@state.showingOptions

  _edit: ->

  _remove: ->
