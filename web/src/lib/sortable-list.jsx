import _ from 'lodash'
import dragula from 'dragula'
import React, { Component } from 'react'
import { findDOMNode } from 'react-dom'

function idsAndIndex (els, el) {
  const ids = _.map(els, 'dataset.id')
  const index = _.findIndex(ids, _.partial(_.isEqual, el.dataset.id))

  return { ids, index }
}

class SortableList extends Component {
  componentDidMount () {
    this._setupSorting()
  }

  componentWillUnmount () {
    this._tearDownSorting()
  }

  _setupSorting () {
    this._tearDownSorting()
    let originalIndex = null
    this.drake = dragula([findDOMNode(this.refs.list)], {
      moves: (el, container, handle) => {
        if (!this.props.handleClass) return true

        let handleEl = handle
        while (handleEl !== el) {
          if (this._hasHandleClass(handleEl)) return true
          handleEl = handleEl.parentElement
        }
        return false
      },
    }).on('drag', (el, container) => {
      originalIndex = idsAndIndex(container.children, el).index
    }).on('drop', (el, container) => {
      const ref = idsAndIndex(container.children, el)
      const ids = ref.ids
      const index = ref.index

      if (originalIndex === container.children.length - 1) {
        container.appendChild(el)
      } else if (index < originalIndex) {
        container.insertBefore(el, container.children[originalIndex + 1])
      } else {
        container.insertBefore(el, container.children[originalIndex])
      }
      this.props.onSortingUpdate(ids)
    })
  }

  _hasHandleClass (el) {
    return el.className.indexOf(this.props.handleClass) >= 0
  }

  _tearDownSorting () {
    if (this.drake) {
      this.drake.destroy()
    }
  }

  render () {
    return React.createElement(this.props.el || 'div', { ref: 'list' }, this.props.children)
  }
}

SortableList.propTypes = {
  onSortingUpdate: React.PropTypes.func.isRequired,
}

export default SortableList
