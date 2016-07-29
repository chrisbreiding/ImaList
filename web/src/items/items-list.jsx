import _ from 'lodash'
import { action } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

import appState from '../app/app-state'

import Item from './item'
import SortableList from '../lib/sortable-list'

@observer
class ItemsList extends Component {
  render () {
    if (this.props.isLoading) {
      return <p className='no-items'><i className='fa fa-hourglass-end fa-spin'></i> Loading...</p>
    } else if (this.props.itemsStore.none) {
      return <p className='no-items'>No List Selected</p>
    } else if (!this.props.itemsStore.items.length) {
      return <p className='no-items'>No Items</p>
    }

    return (
      <SortableList
        ref='list'
        el='ul'
        handleClass='sort-handle'
        onSortingUpdate={this._updateSorting}
      >
        {_.map(this.props.itemsStore.items, (item, index) => (
          <Item
            ref={item.id}
            key={item.id}
            model={item}
            isEditing={item.id === appState.editingItemId}
            isCollapsed={this.props.itemsStore.isCollapsed(item)}
            onEdit={this._editItem}
            onUpdate={this._updateItem}
            onRemove={this._removeItem}
            onNext={() => this._next(index)}
            onToggleCollapsed={this._toggleCollapsed}
          ></Item>
        ))}
      </SortableList>
    )
  }

  @action _next = (index) => {
    const nextItem = this.props.itemsStore.items[index + 1]

    if (!nextItem) {
      this.props.addItem()
    } else if (nextItem.type === 'label') {
      this.props.addItem({ order: nextItem.order })
    } else {
      this._editItem(nextItem, true)
    }
  }

  @action _editItem = (item, shouldEdit) => {
    this.props.itemsStore.editItem(shouldEdit ? item.id : null)
  }

  @action _updateItem = (item) => {
    this.props.itemsStore.updateItem(item)
  }

  @action _removeItem = (item) => {
    this.props.itemsStore.removeItem(item)
  }

  @action _toggleCollapsed = (item) => {
    this.props.itemsStore.toggleCollapsed(item)
  }

  @action _updateSorting = (ids, movedId) => {
    ids = this.props.itemsStore.sorted(ids, movedId)
    _.each(ids, (id, order) => this._updateItem({ id, order }))
  }
}

export default ItemsList
