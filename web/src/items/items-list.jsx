import _ from 'lodash'
import { action, observable } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

import appState from '../app/app-state'

import ActionSheet from '../modal/action-sheet'
import Item from './item'
import SortableList from '../lib/sortable-list'

@observer
class ItemsList extends Component {
  @observable attempingRemoveLabel = null

  render () {
    if (this.props.isLoading) {
      return <p className='no-items'><i className='fa fa-hourglass-end fa-spin'></i> Loading...</p>
    } else if (this.props.itemsStore.none) {
      return <p className='no-items'>No List Selected</p>
    } else if (!this.props.canShow) {
      return <p className='no-items'>Private list - need passcode</p>
    } else if (!this.props.itemsStore.items.length) {
      return <p className='no-items'>No Items</p>
    }

    return (
      <SortableList
        ref='list'
        handleClass='sort-handle'
        onSortingUpdate={this._updateSorting}
        items={this.props.itemsStore.items}
        renderItem={(item, index, onMove) => (
          <Item
            ref={item.id}
            key={item.id}
            id={item.id}
            index={index}
            model={item}
            isEditing={item.id === appState.editingItemId}
            isCollapsed={this.props.itemsStore.isCollapsed(item)}
            onEdit={this._editItem}
            onMove={onMove}
            onUpdate={this._updateItem}
            onRemove={this._attemptRemoveItem}
            onNext={() => this._next(index)}
            onToggleCollapsed={this._toggleCollapsed}
          />
        )}
      >
        <ActionSheet
          isShowing={!!this.attempingRemoveLabel}
          actions={[
            {
              label: 'Remove label and all its items',
              handler: this._removeLabelAndItems,
            }, {
              label: 'Remove label only',
              handler: this._removeLabel,
            }, {
              label: 'Cancel',
              handler: this._cancelRemoveLabel,
              type: 'cancel',
            },
          ]}
        />
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

  @action _attemptRemoveItem = (item) => {
    if (item.type === 'label') {
      const associatedItems = this.props.itemsStore.associatedItemsForLabel(item).value()
      if (associatedItems.length) {
        this.attempingRemoveLabel = item
      } else {
        this._removeItem(item)
      }
    } else {
      this._removeItem(item)
    }
  }

  @action _removeItem = (item) => {
    this.props.itemsStore.removeItem(item)
  }

  @action _removeLabelAndItems = () => {
    this.props.itemsStore.removeLabelAndItems(this.attempingRemoveLabel)
    this.attempingRemoveLabel = null
  }

  @action _removeLabel = () => {
    this._removeItem(this.attempingRemoveLabel)
    this.attempingRemoveLabel = null
  }

  @action _cancelRemoveLabel = () => {
    this.attempingRemoveLabel = null
  }

  @action _toggleCollapsed = (item) => {
    this.props.itemsStore.toggleCollapsed(item)
  }

  @action _updateSorting = (ids, movedId) => {
    ids = this.props.itemsStore.sorted(ids, movedId)
    this.props.itemsStore.expand(this.props.itemsStore.itemById(movedId))
    _.each(ids, (id, order) => this._updateItem({ id, order }))
  }
}

export default ItemsList
