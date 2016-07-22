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

  lists () {
    return _(this._lists.values())
      .sortBy('order')
      .filter((list) => list.shared || list.owner === authState.userEmail)
      .value()
  }

  selectedList (lists) {
    const userSelectedId = this.selectedId || null
    const fallbackId = lists[0] && lists[0].id
    const selectedId = userSelectedId || fallbackId

    const selected = _.find(lists, { id: selectedId })
    const fallback = _.find(lists, { id: fallbackId })

    return selected || fallback || { itemsStore: { items: () => ({}) } }
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

    firebase.getRef().on('value', action('data:loaded', () => {
      this.isLoading = false
      // TODO: remove listener here? is there a .once()?
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

  addList (lists, email) {
    const order = lists.length ? Math.max(..._.map(lists, 'order')) + 1 : 0
    const newRef = firebase.getRef().child('lists').push(this._newList({ order, owner: email }), action('added:list', () => {
      this.editList(newRef.key)
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

  editList (listId) {
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

export default new ListsStore()
