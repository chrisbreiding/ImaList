import { observable } from 'mobx'

class AuthState {
  @observable attemptingLogin = false
  @observable attemptingLogout = false
  @observable userEmail = null
  @observable isAuthenticated = false
  @observable loginFailed = false
}

export default new AuthState()
