import _ from 'lodash'
import { action } from 'mobx'

import firebase from '../data/firebase'
import localStore from '../data/local-store'

class ItemsApi {
  constructor (listId) {
    this.listId = listId
  }

  fetchCollapsed () {
    return (localStore.get('collapsed') || {})[this.listId]
  }

  saveCollapsed (collapsed) {
    const stored = localStore.get('collapsed') || {}
    if (_.keys(collapsed).length) {
      stored[this.listId] = collapsed
    } else {
      delete stored[this.listId]
    }
    localStore.set('collapsed', stored)
  }

  listen (callbacks) {
    this.callbacks = callbacks
    firebase.getRef().child(`lists/${this.listId}/items`).on('child_added', this._itemAdded)
    firebase.getRef().child(`lists/${this.listId}/items`).on('child_changed', this._itemUpdated)
    firebase.getRef().child(`lists/${this.listId}/items`).on('child_removed', this._itemRemoved)
  }

  @action _itemAdded = (childSnapshot) => {
    this.callbacks.onAdd(childSnapshot.key, childSnapshot.val())
  }

  @action _itemUpdated = (childSnapshot) => {
    this.callbacks.onUpdate(childSnapshot.key, childSnapshot.val())
  }

  @action _itemRemoved = (childSnapshot) => {
    this.callbacks.onRemove(childSnapshot.key, childSnapshot.val())
  }

  stopListening () {
    firebase.getRef().child(`lists/${this.listId}/items`).off()
  }

  addItem (item, cb) {
    return firebase.getRef().child(`lists/${this.listId}/items`).push(item, cb)
  }

  updateItem (item) {
    firebase.getRef().child(`lists/${this.listId}/items/${item.id}`).update(item)
  }

  removeItem (item) {
    firebase.getRef().child(`lists/${this.listId}/items/${item.id}`).remove()
  }
}

export default ItemsApi
