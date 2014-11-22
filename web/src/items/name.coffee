React = require 'react/addons'
_ = require 'lodash'

Textarea = React.createFactory require '../lib/growing-textarea'

module.exports = React.createClass

  render: ->
    Textarea
      ref: 'name'
      className: 'name'
      defaultValue: @props.name
      onFocus: _.partial @_updateEditingStatus, true
      onBlur: _.partial @_updateEditingStatus, false
      onChange: @_updateName

  edit: ->
    domNode = @getDOMNode()
    domNode.focus()

    return unless domNode.setSelectionRange

    domNode.setSelectionRange domNode.value.length, domNode.value.length

  _updateEditingStatus: (editing)->
    @props.onEditingStatusChange editing
    setTimeout =>
      @refs.name.recalculateSize()
    , 300

  _updateName: _.debounce ->
    @props.onUpdate @getDOMNode().value
  , 500
