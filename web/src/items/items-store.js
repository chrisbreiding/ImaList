import _ from 'lodash'
import { action, computed, map, observable } from 'mobx'

import appState from '../app/app-state'
import firebase from '../data/firebase'
import Item from './item-model'
import localStore from '../data/local-store'

// TODO: move firebase stuff into items-api.js

class ItemsStore {
  @observable _items = map()
  @observable _collapsed

  constructor (listId) {
    this.listId = listId
    this._collapsed = map((localStore.get('collapsed') || {})[listId])
  }

  @computed get items () {
    return _.sortBy(this._items.values(), 'order')
  }

  @computed get _collapsedItems () {
    const collapsed = {}
    const items = this._items.values()
    if (!items.length) return collapsed

    _.each(this._collapsed.keys(), (id) => {
      const label = _.find(items, { id })
      let hitNextLabel = false
      _.each(this.items, (item) => {
        if (item.order < label.order) return
        if (item.id !== id && item.type === 'label') hitNextLabel = true
        if (hitNextLabel) return
        collapsed[item.id] = true
      })
    })
    return collapsed
  }

  @computed get hasCheckedItems () {
    return _.some(this._items.values(), { isChecked: true })
  }

  listen () {
    firebase.getRef().child(`lists/${this.listId}/items`).on('child_added', action('item:added', (childSnapshot) => {
      this._itemAdded(childSnapshot.key, childSnapshot.val())
    }))

    firebase.getRef().child(`lists/${this.listId}/items`).on('child_changed', action('item:changed', (childSnapshot) => {
      this._itemUpdated(childSnapshot.key, childSnapshot.val())
    }))

    firebase.getRef().child(`lists/${this.listId}/items`).on('child_removed', action('item:removed', (childSnapshot) => {
      this._itemRemoved(childSnapshot.key)
    }))
  }

  _itemAdded (id, item) {
    this._items.set(id, new Item(id, item))
  }

  _itemUpdated (id, item) {
    this._items.get(id).update(item)
  }

  _itemRemoved (id) {
    this._items.delete(id)
  }

  stopListening () {
    firebase.getRef().off()
  }

  _newOrder (collapsedItems) {
    if (collapsedItems[0]) {
      return collapsedItems[0].order
    } else {
      return this._items.size ? _.last(this.items).order + 1 : 0
    }
  }

  _newItem ({ order, type = 'todo', name = '' }) {
    return {
      order,
      type,
      name,
      isChecked: false,
    }
  }

  addItem ({ type }) {
    // add item before the last non-collapsed item or at the end if
    // there are no collapsed items
    const collapsedItems = this._trailingCollapsed()
    const order = this._newOrder(collapsedItems)
    const newItem = this._newItem({ order, type })

    this._reorderCollapsed(collapsedItems, order + 1)
    const newRef = this._addItemToFirebase(newItem, action('added:item', () => {
      appState.editingItemId = newRef.key
    }))
  }

  bulkAdd (names) {
    // same as addItem, but account for adding multiple items
    const collapsedItems = this._trailingCollapsed()
    const startingOrder = this._newOrder(collapsedItems)
    const newItems = _(names)
      .reject((name) => !name.trim())
      .map((name, index) => this._newItem({ name, order: startingOrder + index }))
      .value()

    this._reorderCollapsed(collapsedItems, startingOrder + newItems.length)
    _.each(newItems, (item) => this._addItemToFirebase(item))
  }

  _addItemToFirebase (item, cb) {
    return firebase.getRef().child(`lists/${this.listId}/items`).push(item, cb)
  }

  _trailingCollapsed () {
    return _.takeRightWhile(this.items, (item) => this.isCollapsed(item))
  }

  _reorderCollapsed (collapsedItems, fromOrder) {
    _.each(collapsedItems, (item, index) => {
      this.updateItem({ id: item.id, order: fromOrder + index })
    })
  }

  editItem (id) {
    appState.editingItemId = id
  }

  updateItem (item) {
    firebase.getRef().child(`lists/${this.listId}/items/${item.id}`).update(item)
  }

  removeItem (item) {
    this._expand(item)
    firebase.getRef().child(`lists/${this.listId}/items/${item.id}`).remove()
  }

  isCollapsed (item) {
    return !!this._collapsedItems[item.id]
  }

  toggleCollapsed (label) {
    const isCollapsed = this._collapsed.get(label.id)
    if (isCollapsed) {
      this._expand(label)
    } else {
      this._collapse(label)
    }
  }

  _collapse (label) {
    this._collapsed.set(label.id, true)
    this._saveCollapsed()
  }

  _expand (label) {
    this._collapsed.delete(label.id)
    this._saveCollapsed()
  }

  expandAll () {
    this._collapsed = map()
    this._saveCollapsed()
  }

  _saveCollapsed () {
    const collapsed = localStore.get('collapsed') || {}
    if (this._collapsed.size) {
      collapsed[this.listId] = this._collapsed.toJS()
    } else {
      delete collapsed[this.listId]
    }
    localStore.set('collapsed', collapsed)
  }

  clearCompleted () {
    _.each(this._items.values(), (item) => {
      if (item.isChecked) {
        firebase.getRef().child(`lists/${this.listId}/items/${item.id}`).remove()
      }
    })
  }
}

export default ItemsStore
