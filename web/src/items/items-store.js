import _ from 'lodash'
import { action, computed, map, observable } from 'mobx'

import appState from '../app/app-state'
import Item from './item-model'
import ItemsApi from './items-api'

class ItemsStore {
  @observable _items = map()
  @observable _collapsed

  constructor (listId) {
    this.listId = listId
    this.itemsApi = new ItemsApi(listId)
    this._collapsed = map(this.itemsApi.fetchCollapsed())
  }

  @computed get items () {
    return _.sortBy(this._items.values(), 'order')
  }

  @computed get _collapsedItems () {
    const collapsed = {}
    const items = this.items
    if (!items.length) return collapsed

    _.each(this._collapsed.keys(), (id) => {
      const label = this._items.get(id)
      if (!label) return // label may be gone if removed on another device
      collapsed[label.id] = true
      this.associatedItemsForLabel(label).each((item) => {
        collapsed[item.id] = true
      })
    })
    return collapsed
  }

  @computed get hasCheckedItems () {
    return _.some(this._items.values(), { isChecked: true })
  }

  itemById (id) {
    return this._items.get(id)
  }

  associatedItemsForLabel (label) {
    return _(this.items)
      .dropWhile((item) => item.order <= label.order)
      .takeWhile((item) => item.type !== 'label')
  }

  listen () {
    this.itemsApi.listen({
      onAdd: (id, item) => { this._items.set(id, new Item(id, item)) },
      onUpdate: (id, item) => { this._items.get(id).update(item) },
      onRemove: (id) => {
        const item = this._items.get(id)
        this.expand(item)
        this._items.delete(id)
      },
    })
  }

  stopListening () {
    this.itemsApi.stopListening()
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

  addItem ({ type, order }) {
    let reorderItems = []
    if (order != null) {
      // if order is specified, reorder everything after
      reorderItems = _.takeRightWhile(this.items, (item) => item.order >= order)
    } else if (type === 'label') {
      // always add labels to end
      order = this._newOrder([])
    } else {
      // add before the last non-collapsed item or at the end if
      // there are no collapsed items
      reorderItems = this._trailingCollapsed()
      order = this._newOrder(reorderItems)
    }
    const newItem = this._newItem({ order, type })

    this._reorder(reorderItems, order + 1)
    const newRef = this.itemsApi.addItem(newItem, action('added:item', () => {
      appState.editingItemId = newRef.key
    }))
  }

  bulkAdd (names) {
    // similar to addItem, but account for adding multiple items
    const trailingCollapsed = this._trailingCollapsed()
    const startingOrder = this._newOrder(trailingCollapsed)
    const newItems = _(names)
      .reject((name) => !name.trim())
      .map((name, index) => this._newItem({ name, order: startingOrder + index }))
      .value()

    this._reorder(trailingCollapsed, startingOrder + newItems.length)
    _.each(newItems, (item) => this.itemsApi.addItem(item))
  }

  _trailingCollapsed () {
    return _.takeRightWhile(this.items, (item) => this.isCollapsed(item))
  }

  _reorder (items, fromOrder) {
    _.each(items, (item, index) => {
      this.updateItem({ id: item.id, order: fromOrder + index })
    })
  }

  sorted (ids, movedId) {
    const item = this._items.get(movedId)
    if (item.type !== 'label' || !this.isCollapsed(item)) return ids

    const movedIndex = _.findIndex(ids, (id) => id === movedId)
    const itemsToMove = this.associatedItemsForLabel(item).value()
    if (!itemsToMove.length) return ids

    const itemIndex = _.findIndex(ids, (id) => id === itemsToMove[0].id)
    const itemIds = ids.splice(itemIndex, itemsToMove.length)
    const moveTo = (movedIndex > itemIndex ? movedIndex - itemsToMove.length : movedIndex) + 1
    ids.splice(moveTo, 0, ...itemIds)
    return ids
  }

  editItem (id) {
    appState.editingItemId = id
  }

  updateItem (item) {
    this.itemsApi.updateItem(item)
  }

  removeItem = (item) => {
    this.itemsApi.removeItem(item)
  }

  removeLabelAndItems (label) {
    this.removeItem(label)
    this.associatedItemsForLabel(label).each(this.removeItem)
  }

  isCollapsed (item) {
    return !!this._collapsedItems[item.id]
  }

  toggleCollapsed (label) {
    const isCollapsed = this._collapsed.get(label.id)
    if (isCollapsed) {
      this.expand(label)
    } else {
      this._collapse(label)
    }
  }

  _collapse (label) {
    this._collapsed.set(label.id, true)
    this._saveCollapsed()
  }

  expand (label) {
    this._collapsed.delete(label.id)
    this._saveCollapsed()
  }

  expandAll () {
    this._collapsed = map()
    this._saveCollapsed()
  }

  _saveCollapsed () {
    this.itemsApi.saveCollapsed(this._collapsed.toJS())
  }

  clearCompleted () {
    _.each(this._items.values(), (item) => {
      if (item.isChecked) {
        this.itemsApi.removeItem(item)
      }
    })
  }
}

export default ItemsStore
