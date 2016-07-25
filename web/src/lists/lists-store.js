import _ from 'lodash'
import { action, computed, map, observable } from 'mobx'

import authState from '../login/auth-state'
import firebase from '../data/firebase'
import List from './list-model'
import localStore from '../data/local-store'

// TODO: move firebase stuff into lists-api.js

class ListsStore {
  @observable _lists = map()
  @observable attemptingRemoveListId = null
  @observable isLoading = false
  @observable editingListId = null
  @observable selectedId = localStore.get('selectedListId') || null

  @computed get showingItems () {
    return !!this.selectedId
  }

  @computed get lists () {
    return _(this._lists.values())
      .sortBy('order')
      .filter((list) => list.shared || list.owner === authState.userEmail)
      .value()
  }

  @computed get selectedList () {
    const selected = _.find(this.lists, { id: this.selectedId })
    return selected || { itemsStore: { items: [], none: true } }
  }

  listen () {
    action('begin:loading:data', () => this.isLoading = true)()

    firebase.getRef().child('lists').on('child_added', action('list:added', (childSnapshot) => {
      this._listAdded(childSnapshot.key, childSnapshot.val())
    }))

    firebase.getRef().child('lists').on('child_changed', action('list:changed', (childSnapshot) => {
      this._listUpdated(childSnapshot.key, childSnapshot.val())
    }))

    firebase.getRef().child('lists').on('child_removed', action('list:removed', (childSnapshot) => {
      this._listRemoved(childSnapshot.key)
    }))

    firebase.getRef().once('value', action('data:loaded', () => {
      this.isLoading = false
    }))
  }

  _listAdded (id, list) {
    this._lists.set(id, new List(id, list))
  }

  _listUpdated (id, list) {
    this._lists.get(id).update(list)
  }

  _listRemoved (id) {
    this._lists.get(id).willRemove()
    this._lists.delete(id)
  }

  stopListening () {
    firebase.getRef().off()
  }

  selectList (listId = null) {
    localStore.set({ selectedListId: listId })
    this.selectedId = listId
  }

  addList () {
    const lists = this.lists
    const order = lists.length ? Math.max(..._.map(lists, 'order')) + 1 : 0
    const newList = this._newList({ order, owner: authState.userEmail })
    const newRef = firebase.getRef().child('lists').push(newList, action('added:list', () => {
      this._editList(newRef.key)
    }))
  }

  _newList ({ order, owner }) {
    return {
      order,
      owner,
      name: '',
      items: {},
      shared: false,
    }
  }

  _editList (listId) {
    this.editingListId = listId
  }

  updateList (list) {
    firebase.getRef().child(`lists/${list.id}`).update(list)
  }

  attemptRemoveList (listId) {
    this.attemptingRemoveListId = listId
  }

  removeList (id) {
    firebase.getRef().child(`lists/${id}`).remove()
    this.attemptingRemoveListId = null
  }
}

export default ListsStore
