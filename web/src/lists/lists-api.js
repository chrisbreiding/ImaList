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

    this._stopListening = firebase.watchCollection('lists', {
      added: this._listAdded,
      modified: this._listUpdated,
      removed: this._listRemoved,
    })
    firebase.whenLoaded().then(this._dataLoaded)
  }

  @action _listAdded = ({ id, value: list }) => {
    this.callbacks.onAdd(id, list)
  }

  @action _listUpdated = ({ id, value: list }) => {
    this.callbacks.onUpdate(id, list)
  }

  @action _listRemoved = ({ id, value: list }) => {
    this.callbacks.onRemove(id, list)
  }

  @action _dataLoaded = () => {
    this.callbacks.onDataLoad()
  }

  stopListening () {
    this._stopListening && this._stopListening()
  }

  addList (list) {
    return firebase.add('lists', list)
  }

  updateList (list) {
    firebase.update(`lists/${list.id}`, list)
  }

  removeList (list) {
    firebase.remove(`lists/${list.id}`)
  }
}

export default ListsApi
