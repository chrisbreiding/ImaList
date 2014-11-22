React = require 'react/addons'
_ = require 'lodash'

RD = React.DOM

module.exports = React.createClass

  render: ->
    el = RD.textarea
    name = @props.name

    unless @props.multiline
      el = RD.input
      name = @props.name.split('\n')[0]

    el
      className: 'name'
      defaultValue: name
      onClick: @_edit
      onChange: @_updateName
      onKeyUp: @_keyup

  edit: ->
    domNode = @getDOMNode()
    domNode.focus()

    return unless domNode.setSelectionRange

    domNode.setSelectionRange domNode.value.length, domNode.value.length
    @props.onEdit true

  _edit: (e)->
    e.stopPropagation()
    @props.onEdit true
    setTimeout => @getDOMNode().focus()

  _keyup: (e)->
    if e.key is 'Enter' and @_hasValue() and @_isntMultiline()
      @props.onNext()

  _hasValue: ->
    (@getDOMNode().value or '').trim() isnt ''

  _isntMultiline: ->
    not @props.multiline

  _updateName: _.debounce ->
    @props.onUpdate @getDOMNode().value
  , 500
