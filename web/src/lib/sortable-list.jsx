import _ from 'lodash'
import React, { Component } from 'react'
import { findDOMNode } from 'react-dom'
import { DragDropContext } from 'react-dnd'
import HTML5Backend from 'react-dnd-html5-backend'

export const sortableSource = {
  beginDrag ({ id, index }) {
    return { id, index }
  },

  // endDrag
}

export const sortableTarget = {
  hover (props, monitor, component) {
    const dragIndex = monitor.getItem().index
    const hoverIndex = props.index

    // don't replace items with themselves
    if (dragIndex === hoverIndex) return

    const hoverBoundingRect = findDOMNode(component).getBoundingClientRect()
    const hoverMiddleY = (hoverBoundingRect.bottom - hoverBoundingRect.top) / 2
    const clientOffset = monitor.getClientOffset()
    const hoverClientY = clientOffset.y - hoverBoundingRect.top

    // only perform the move when the mouse has crossed half of the items height
    // when dragging downwards, only move when the cursor is below 50%
    // when dragging upwards, only move when the cursor is above 50%

    // dragging downwards
    if (dragIndex < hoverIndex && hoverClientY < hoverMiddleY) return
    // dragging upwards
    if (dragIndex > hoverIndex && hoverClientY > hoverMiddleY) return

    props.onMove(dragIndex, hoverIndex)

    // note: we're mutating the monitor item here!
    // generally it's better to avoid mutations,
    // but it's good here for the sake of performance
    // to avoid expensive index searches.
    monitor.getItem().index = hoverIndex
  },
}

@DragDropContext(HTML5Backend)
class SortableList extends Component {
  render () {
    const { items, renderItem } = this.props

    return (
      <ul>
        {items.map((item, index) => (
          renderItem(item, index, this._onMove)
        ))}
        {this.props.children}
      </ul>
    )
  }

  _onMove = (fromIndex, toIndex) => {
    const { items } = this.props
    const ids = _.map(items, 'id')
    const movedId = ids[fromIndex]
    ids.splice(toIndex, 0, ids.splice(fromIndex, 1)[0])

    this.props.onSortingUpdate(ids, movedId)
  }
}

export default SortableList
