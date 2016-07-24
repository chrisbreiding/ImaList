import _ from 'lodash'
import { action, computed, map, observable } from 'mobx'

import appState from '../app/app-state'
import firebase from '../data/firebase'
import Item from './item-model'

// TODO: move firebase stuff into items-api.js

class ItemsStore {
  @observable _items = map()

  constructor (listId) {
    this.listId = listId
  }

  @computed get items () {
    return _.sortBy(this._items.values(), 'order')
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

  _newOrder () {
    return this._items.size ? Math.max(..._.map(this._items.values(), 'order')) + 1 : 0
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
    const order = this._newOrder()
    const newRef = firebase.getRef().child(`lists/${this.listId}/items`)
      .push(this._newItem({ order, type }), action('added:item', () => {
        appState.editingItemId = newRef.key
      }))
  }

  bulkAdd (names) {
    const startingOrder = this._newOrder()
    _(names)
      .reject((name) => !name.trim())
      .map((name, index) => this._newItem({ name, order: startingOrder + index }))
      .each((item) => {
        firebase.getRef().child(`lists/${this.listId}/items`).push(item)
      })
  }

  editItem (id) {
    appState.editingItemId = id
  }

  updateItem (item) {
    firebase.getRef().child(`lists/${this.listId}/items/${item.id}`).update(item)
  }

  removeItem (item) {
    this.expand(item)
    firebase.getRef().child(`lists/${this.listId}/items/${item.id}`).remove()
  }

  toggleCollapsed (label) {
    this._setCollapsed(label, !label.isCollapsed)
  }

  expand (label) {
    this._setCollapsed(label, false)
  }

  _setCollapsed (label, isCollapsed) {
    label.isCollapsed = isCollapsed
    let hitNexLabel = false
    _.each(this.items, (item) => {
      if (item.order <= label.order) return
      if (item.type === 'label') hitNexLabel = true
      if (hitNexLabel) return

      item.isCollapsed = isCollapsed
    })
  }

  expandAll () {
    _.each(this.items, (item) => {
      item.isCollapsed = false
    })
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
