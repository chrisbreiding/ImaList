import { action } from 'mobx'

import firebase from '../data/firebase'
import localStore from '../data/local-store'

class ListsApi {
  fetchSelectedList () {
    return localStore.get('selectedListId')
  }

  saveSelectedList (selectedListId) {
    localStore.set({ selectedListId })
  }

  listen (callbacks) {
    this.callbacks = callbacks
    firebase.getRef().child('lists').on('child_added', this._listAdded)
    firebase.getRef().child('lists').on('child_changed', this._listUpdated)
    firebase.getRef().child('lists').on('child_removed', this._listRemoved)
    firebase.getRef().once('value', this._dataLoaded)
  }

  @action _listAdded = (childSnapshot) => {
    this.callbacks.onAdd(childSnapshot.key, childSnapshot.val())
  }

  @action _listUpdated = (childSnapshot) => {
    this.callbacks.onUpdate(childSnapshot.key, childSnapshot.val())
  }

  @action _listRemoved = (childSnapshot) => {
    this.callbacks.onRemove(childSnapshot.key)
  }

  @action _dataLoaded = () => {
    this.callbacks.onDataLoad()
  }

  stopListening () {
    firebase.getRef().off()
  }

  addList (list, cb) {
    return firebase.getRef().child('lists').push(list, cb)
  }

  updateList (list) {
    firebase.getRef().child(`lists/${list.id}`).update(list)
  }

  removeList (list) {
    firebase.getRef().child(`lists/${list.id}`).remove()
  }
}

export default ListsApi
