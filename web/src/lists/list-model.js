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
    this.name = props.name
    this.order = props.order
    this.owner = props.owner
    this.shared = props.shared
    this.isPrivate = props.isPrivate
  }

  willRemove () {
    this.itemsStore.stopListening()
  }
}

export default List
