_ = require 'lodash'
dragula = require 'dragula'
React = require 'react'

idsAndIndex = (els, el)->
  ids = _.pluck els, 'dataset.id'
  index = _.findIndex ids, _.partial(_.isEqual, el.dataset.id)
  { ids, index }

module.exports = React.createClass
  displayName: 'SortableList'

  propTypes:
    onSortingUpdate: React.PropTypes.func.isRequired

  componentDidMount: ->
    @_setupSorting()

  componentWillUnmount: ->
    @_tearDownSorting()

  _setupSorting: ->
    @_tearDownSorting()

    originalIndex = null
    @drake = dragula [ @getDOMNode() ], {
      moves: (el, container, handle)=>
        return true unless @props.handleClass

        handleEl = handle
        while handleEl isnt el
          return true if @_hasHandleClass handleEl
          handleEl = handleEl.parentElement

        false
    }
      .on 'drag', (el, container)=>
        originalIndex = idsAndIndex(container.children, el).index

      .on 'drop', (el, container)=>
        { ids, index } = idsAndIndex(container.children, el)

        if originalIndex is container.children.length - 1
          container.appendChild(el)
        else if index < originalIndex
          container.insertBefore el, container.children[originalIndex + 1]
        else
          container.insertBefore el, container.children[originalIndex]

        @props.onSortingUpdate(ids)

  _hasHandleClass: (el)->
    el.className.indexOf(@props.handleClass) >= 0

  _tearDownSorting: ->
    @drake.destroy() if @drake

  render: ->
    React.DOM[@props.el || 'div'] null, @props.children
