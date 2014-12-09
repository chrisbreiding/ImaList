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
      onKeyUp: @_onKeyUp
      onKeyDown: @_onKeyDown

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

  _onKeyDown: (e)->
    e.preventDefault() if e.key is 'Enter' and not e.shiftKey

  _onKeyUp: (e)->
    if e.key is 'Enter' and not e.shiftKey and @_hasValue()
      @props.onNext()
    else
      @_updateName()

  _hasValue: ->
    (@getDOMNode().value or '').trim() isnt ''
