import _ from 'lodash'
import { action, computed, map, observable } from 'mobx'

import authState from '../auth/auth-state'
import List from './list-model'
import ListsApi from './lists-api'

class ListsStore {
  @observable _lists = map()
  @observable editingListId = null
  @observable isLoading = false
  @observable selectedListId = null

  constructor () {
    this.listsApi = new ListsApi()
    action('fetch:selected:list', () => {
      this.selectedListId = this.listsApi.fetchSelectedList()
    })()
  }

  @computed get showingItems () {
    return !!this.selectedListId
  }

  @computed get lists () {
    return _(this._lists.values())
      .sortBy('order')
      .filter((list) => list.shared || list.owner === authState.user.email)
      .value()
  }

  @computed get selectedList () {
    const selected = _.find(this.lists, { id: this.selectedListId })
    return selected || { itemsStore: { items: [], none: true } }
  }

  listen () {
    action('begin:loading:data', () => this.isLoading = true)()
    this.listsApi.listen({
      onAdd: (id, list) => { this._lists.set(id, new List(id, list)) },
      onUpdate: (id, list) => { this._lists.get(id).update(list) },
      onRemove: (id) => {
        this._lists.get(id).willRemove()
        this._lists.delete(id)
      },
      onDataLoad: () => { this.isLoading = false },
    })
  }

  stopListening () {
    this.listsApi.stopListening()
  }

  selectList (list) {
    const id = list ? list.id : null
    this.listsApi.saveSelectedList(id)
    this.selectedListId = id
  }

  addList () {
    const lists = this.lists
    const order = lists.length ? Math.max(..._.map(lists, 'order')) + 1 : 0
    const newList = this._newList({ order, owner: authState.user.email })
    const newRef = this.listsApi.addList(newList, action('added:list', () => {
      this.editList({ id: newRef.key })
    }))
  }

  editList (list) {
    this.editingListId = list.id
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

  updateList (list) {
    this.listsApi.updateList(list)
  }

  removeList (list) {
    this.listsApi.removeList(list)
  }
}

export default ListsStore
