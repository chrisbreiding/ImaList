import { observable } from 'mobx'
import User from './user-model'

class AuthState {
  @observable attemptingLogin = false
  @observable attemptingLogout = false
  @observable user = new User()
  @observable isAuthenticated = false
  @observable loginFailed = false

  @observable passcodeAction
  afterReceivingPasscode = () => {}
}

export default new AuthState()
