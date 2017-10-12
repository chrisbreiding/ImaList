import _ from 'lodash'
import { observable } from 'mobx'

class Item {
  @observable id
  @observable name
  @observable order = 0
  @observable type
  @observable isChecked = false

  constructor (id, props) {
    this.id = id
    this.update(props)
  }

  update (props) {
    _.extend(this, _.pick(props, 'name', 'order', 'type', 'isChecked'))
  }
}

export default Item
