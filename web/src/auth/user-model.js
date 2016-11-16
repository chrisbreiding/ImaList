import { computed, observable } from 'mobx'

class User {
  @observable id
  @observable email
  @observable hashedPasscode

  constructor ({ id, email } = {}) {
    this.id = id
    this.email = email
  }

  @computed get hasPasscode () {
    return !!this.hashedPasscode
  }
}

export default User
