import { action, observable } from 'mobx'
import User from './user-model'

function noop () {}

class AuthState {
  @observable attemptingLogin = false
  @observable attemptingLogout = false
  @observable user
  @observable isAuthenticated = false
  @observable loginFailed = false

  @observable passcodeNeeded = false
  onPasscodeSubmit = noop
  onPasscodeCancel = noop

  constructor () {
    action('create:user', () => {
      this.user = new User()
    })()
  }

  resetPasscodeCallbacks () {
    this.onPasscodeSubmit = noop
    this.onPasscodeCancel = noop
  }
}

export default new AuthState()
