import cs from 'classnames'
import _ from 'lodash'
import { action, observable } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

import appState from '../app/app-state'

import ActionSheet from '../modal/action-sheet'
import BulkAdd from './bulk-add'
import Item from './item'
import SortableList from '../lib/sortable-list'

@observer
class Items extends Component {
  @observable attemptingClearCompleted = false
  @observable bulkAddingItems = false
  @observable isEditing = false

  render () {
    return (
      <div
        className={cs({
          'items': true,
          'editing': this.isEditing,
        })}
      >
        <header className='fixed'>
          <h1>{this.props.list.name}</h1>
          <button className='back' onClick={this._onBack}>
            <i className='fa fa-chevron-left'></i>
          </button>
          <button className='edit' onClick={this._toggleEditing}>
            {this.isEditing ? <span>Done</span> : <i className='fa fa-sort'></i>}
          </button>
        </header>
        {this._items()}
        <footer>
          <button onClick={() => this._addItem()}>
            <span>Item</span>
            <i className='fa fa-plus'></i>
          </button>
          <button onClick={() => this._addItem('label')}>
            <span>Label</span>
            <i className='fa fa-plus-square'></i>
          </button>
          <button onClick={() => this._attemptBulkAdd()}>
            <span>Bulk</span>
            <i className='fa fa-plus-square-o'></i>
          </button>
          <div className='spacer'></div>
          {this._clearCompletedButton()}
        </footer>
        <BulkAdd
          isShowing={this.bulkAddingItems}
          onCancel={this._cancelBulkAdd}
          onAdd={this._bulkAddItems}
        />
        <ActionSheet
          isShowing={this.attemptingClearCompleted}
          confirmMessage='Clear Completed'
          onConfirm={this._clearCompleted}
          onCancel={this._cancelClearCompleted}
        />
      </div>
    )
  }

  // TODO: optimize by moving to own component
  _items () {
    if (this.props.isLoading) {
      return <p className='no-items'><i className='fa fa-hourglass-end fa-spin'></i> Loading...</p>
    } else if (!this.props.list.itemsStore.items.length) {
      return <p className='no-items'>No Items</p>
    }

    return (
      <SortableList
        ref='list'
        el='ul'
        handleClass='sort-handle'
        onSortingUpdate={this._sortingUpdated}
      >
      {_.map(this.props.list.itemsStore.items, (item, index) => (
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

  _clearCompletedButton () {
    if (!_.some(this.props.list.itemsStore.items, { isChecked: true })) return null

    return (
      <button className='clear-completed' onClick={this._attemptClearCompleted}>
        <span>Clear <i className='fa fa-check-square-o'></i></span>
        <i className='fa fa-ban'></i>
      </button>
    )
  }

  @action _attemptClearCompleted = () => {
    this.attemptingClearCompleted = true
  }

  @action _cancelClearCompleted = () => {
    this.attemptingClearCompleted = false
  }

  @action _clearCompleted = () => {
    this.attemptingClearCompleted = false
    this.props.list.itemsStore.clearCompleted(this.props.list)
  }

  @action _next (index) {
    const items = this.props.list.itemsStore.items
    if (index === items.length - 1) {
      this._addItem()
    } else {
      this._editItem(items[index + 1], true)
    }
  }

  @action _editItem (item, shouldEdit) {
    this.props.list.itemsStore.editItem(shouldEdit ? item.id : null)
  }

  @action _onBack = () => {
    this.isEditing = false
    this.props.onShowLists()
  }

  @action _toggleEditing = () => {
    this.isEditing = !this.isEditing
  }

  @action _addItem (type) {
    this.props.list.itemsStore.addItem({ type })
  }

  @action _updateItem (item) {
    this.props.list.itemsStore.updateItem(item)
  }

  @action _removeItem (item) {
    this.props.list.itemsStore.removeItem(item)
  }

  @action _toggleCollapsed = (item) => {
    this.props.list.itemsStore.toggleCollapsed(item)
  }

  @action _sortingUpdated = (ids) => {
    this.props.list.itemsStore.expandAll()
    _.each(ids, (id, order) => this._updateItem({ id, order }))
  }

  @action _attemptBulkAdd = () => {
    this.bulkAddingItems = true
  }

  @action _cancelBulkAdd = () => {
    this.bulkAddingItems = false
  }

  @action _bulkAddItems = (names) => {
    this.bulkAddingItems = false
    this.props.list.itemsStore.bulkAdd(names)
  }
}

export default Items
