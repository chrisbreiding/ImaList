React = require 'react/addons'
_ = require 'lodash'

RD = React.DOM

module.exports = React.createClass

  render: ->
    RD.input
      className: 'name'
      defaultValue: @props.name
      onFocus: _.partial @props.onEditingStatusChange, true
      onBlur: _.partial @props.onEditingStatusChange, false
      onChange: @_updateName
      onKeyUp: @_keyup

  edit: ->
    domNode = @getDOMNode()
    domNode.focus()

    return unless domNode.setSelectionRange

    domNode.setSelectionRange domNode.value.length, domNode.value.length

  _keyup: (e)->
    if e.key is 'Enter' and @_hasValue()
      @props.onNext()

  _hasValue: ->
    (@getDOMNode().value or '').trim() isnt ''

  _updateName: _.debounce ->
    @props.onUpdate @getDOMNode().value
  , 500
