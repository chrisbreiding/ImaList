React = require 'react/addons'
_ = require 'lodash'

Textarea = React.createFactory require '../lib/growing-textarea'

module.exports = React.createClass

  render: ->
    Textarea
      ref: 'name'
      className: 'name'
      value: @props.name
      onFocus: _.partial @props.onEditingStatusChange, true
      onBlur: _.partial @props.onEditingStatusChange, false
      onChange: @_updateName
      onKeyDown: @_onKeyDown
      onKeyUp: @_onKeyUp

  edit: ->
    domNode = @getDOMNode()
    domNode.focus()

    return unless domNode.setSelectionRange

    domNode.setSelectionRange domNode.value.length, domNode.value.length

  hasValue: ->
    (@getDOMNode().value or '').trim() isnt ''

  _updateName: ->
    @props.onUpdate @getDOMNode().value

  _onKeyDown: (e)->
    if e.key is 'Enter' and e.shiftKey
      e.preventDefault()

  _onKeyUp: (e)->
    if e.key is 'Enter' and e.shiftKey and @hasValue()
      @props.onNext()
      return
