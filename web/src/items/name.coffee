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
      onKeyUp: @_keyup

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

  _keyup: (e)->
    if e.key is 'Enter' and @_hasValue()
      @props.onNext()

  _hasValue: ->
    (@getDOMNode().value or '').trim() isnt ''

  _updateName: _.debounce ->
    @props.onUpdate @getDOMNode().value
  , 500
