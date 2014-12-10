React = require 'react/addons'
_ = require 'lodash'

Textarea = React.createFactory require '../lib/growing-textarea'

module.exports = React.createClass

  render: ->
    if @props.editing
      Textarea
        ref: 'name'
        className: 'name'
        autofocus: true
        defaultValue: @props.name
        onFocus: _.partial @props.onEditingStatusChange, true
        onBlur: _.partial @props.onEditingStatusChange, false
        onKeyUp: @_onKeyUp
        onKeyDown: @_onKeyDown
    else
      React.DOM.pre
        className: 'name'
        onClick: _.partial @props.onEditingStatusChange, true
        @props.name

  componentDidMount: ->
    @edit() if @props.editing

  componentDidUpdate: ->
    @edit() if @props.editing

  edit: ->
    domNode = @getDOMNode()
    domNode.focus()

    return unless domNode.setSelectionRange

    domNode.setSelectionRange domNode.value.length, domNode.value.length

  _updateName: _.debounce (name)->
    @props.onUpdate name
  , 500

  _onKeyDown: (e)->
    e.preventDefault() if e.key is 'Enter' and not e.shiftKey

  _onKeyUp: (e)->
    if e.key is 'Enter' and not e.shiftKey and @_hasValue()
      @props.onNext()
    else
      @_updateName @getDOMNode().value

  _hasValue: ->
    (@getDOMNode().value or '').trim() isnt ''
