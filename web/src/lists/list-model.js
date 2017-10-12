import _ from 'lodash'
import { observable } from 'mobx'

import ItemsStore from '../items/items-store'

class List {
  @observable id
  @observable name
  @observable order = 0
  @observable owner
  @observable shared = false
  @observable isPrivate = false
  @observable itemsStore

  constructor (id, props) {
    this.id = id
    this._updatePrimitiveProps(props)
    this.itemsStore = new ItemsStore(id)
    this.itemsStore.listen()
  }

  update (props) {
    this._updatePrimitiveProps(props)
  }

  _updatePrimitiveProps (props) {
    _.extend(this, _.pick(props, 'name', 'order', 'owner', 'shared', 'isPrivate'))
  }

  willRemove () {
    this.itemsStore.stopListening()
  }
}

export default List
