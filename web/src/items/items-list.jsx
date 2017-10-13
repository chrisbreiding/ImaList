import _ from 'lodash'
import { action, observable } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'
import { SortableContainer } from 'react-sortable-hoc'

import appState from '../app/app-state'

import ActionSheet from '../modal/action-sheet'
import Item from './item'

@observer
class ItemsList extends Component {
  @observable attempingRemoveLabel = null

  render () {
    return (
      <ul>
        {_.map(this.props.itemsStore.items, (item, index) => {
          const isCollapsed = this.props.itemsStore.isCollapsed(item)

          // index and disabled are for SortableElement
          return (
            <Item
              key={item.id}
              index={index}
              disabled={isCollapsed && item.type !== 'label'}
              model={item}
              isEditing={item.id === appState.editingItemId}
              isCollapsed={isCollapsed}
              onEdit={this._editItem}
              onUpdate={this._updateItem}
              onRemove={this._attemptRemoveItem}
              onNext={() => this._next(index)}
              onToggleCollapsed={this._toggleCollapsed}
            ></Item>
          )
        })}
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
    </ul>
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
}

const SortableItemsList = SortableContainer(ItemsList)

const ItemsListContainer = (props) => {
  const onSortEnd = ({ oldIndex, newIndex }) => {
    if (oldIndex === newIndex) return

    const item = props.itemsStore.items[oldIndex]
    const ids = props.itemsStore.sortedIds(oldIndex, newIndex)
    props.itemsStore.expand(item)
    _.each(ids, (id, order) => props.itemsStore.updateItem({ id, order }))
  }

  if (props.isLoading) {
    return <p className='no-items'><i className='fa fa-hourglass-end fa-spin'></i> Loading...</p>
  } else if (props.itemsStore.none) {
    return <p className='no-items'>No List Selected</p>
  } else if (!props.canShow) {
    return <p className='no-items'>Private list - need passcode</p>
  } else if (!props.itemsStore.items.length) {
    return <p className='no-items'>No Items</p>
  }

  return (
    <SortableItemsList
      {...props}
      helperClass='sorting-helper'
      onSortEnd={onSortEnd}
      useDragHandle={true}
    />
  )
}

export default ItemsListContainer
