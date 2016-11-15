import { observable } from 'mobx'
import User from './user-model'

function noop () {}

class AuthState {
  @observable attemptingLogin = false
  @observable attemptingLogout = false
  @observable user = new User()
  @observable isAuthenticated = false
  @observable loginFailed = false

  @observable passcodeAction
  onPasscodeSubmit = noop
  onPasscodeCancel = noop

  resetPasscodeCallbacks () {
    this.onPasscodeSubmit = noop
    this.onPasscodeCancel = noop
  }
}

export default new AuthState()
