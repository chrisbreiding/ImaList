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
            onEdit={(shouldEdit) => this._editItem(item, shouldEdit)}
            onUpdate={(item) => this._updateItem(item)}
            onRemove={() => this._removeItem(item)}
            onNext={() => this._next(index)}
            onToggleCollapsed={() => this._toggleCollapsed(item)}
          ></Item>
        ))}
      </SortableList>
    )
  }

  @action _next = (index) => {
    if (index === this.props.itemsStore.items.length - 1) {
      this.props.addItem()
    } else {
      this._editItem(this.props.itemsStore.items[index + 1], true)
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

  @action _updateSorting = (ids) => {
    this.props.itemsStore.expandAll()
    _.each(ids, (id, order) => this._updateItem({ id, order }))
  }
}

export default ItemsList
