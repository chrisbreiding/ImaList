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
    this._stopListening = firebase.watchCollection(`lists/${this.listId}/items`, {
      added: this._itemAdded,
      modified: this._itemUpdated,
      removed: this._itemRemoved,
    })
  }

  @action _itemAdded = ({ id, value: item }) => {
    this.callbacks.onAdd(id, item)
  }

  @action _itemUpdated = ({ id, value: item }) => {
    this.callbacks.onUpdate(id, item)
  }

  @action _itemRemoved = ({ id, value: item }) => {
    this.callbacks.onRemove(id, item)
  }

  stopListening () {
    this._stopListening && this._stopListening()
  }

  addItem (item) {
    return firebase.add(`lists/${this.listId}/items`, item)
  }

  updateItem (item) {
    firebase.update(`lists/${this.listId}/items/${item.id}`, item)
  }

  removeItem (item) {
    firebase.remove(`lists/${this.listId}/items/${item.id}`)
  }
}

export default ItemsApi
