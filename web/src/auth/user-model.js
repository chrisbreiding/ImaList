import { observable } from 'mobx'

class User {
  @observable id
  @observable email
  @observable passcode

  constructor ({ id, email } = {}) {
    this.id = id
    this.email = email
  }
}

export default User
