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
    this.name = props.name
    this.order = props.order
    this.type = props.type
    this.isChecked = props.isChecked
  }
}

export default Item
