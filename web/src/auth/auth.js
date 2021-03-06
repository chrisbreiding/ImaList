import md5 from 'md5'
import { action } from 'mobx'

import appState from '../app/app-state'
import authState from './auth-state'
import C from '../data/constants'
import firebase from '../data/firebase'
import User from './user-model'
import UsersApi from './users-api'

class Auth {
  constructor () {
    this.usersApi = new UsersApi()
  }

  isAuthenticated () {
    return !!this._firebaseUser()
  }

  fetchUserData () {
    return this.usersApi.fetchUsersData(authState.user.id).then(this._setUserPasscode)
  }

  listenForUserDataChanges () {
    this.usersApi.listen(authState.user.id, this._setUserPasscode)
  }

  @action _setUserPasscode = (user) => {
    authState.user.hashedPasscode = user ? user.hashedPasscode : undefined
  }

  matchesUserPasscode (passcode) {
    return authState.user.hashedPasscode === md5(passcode)
  }

  updatePasscode (passcode) {
    const hashedPasscode = md5(passcode)
    authState.user.hashedPasscode = hashedPasscode
    this.usersApi.updateUser({ id: authState.user.id, hashedPasscode })
  }

  listenForChange () {
    firebase.onAuthStateChanged(action('auth:state:changed', () => {
      this._updateAuthStatus()
    }))
  }

  _updateAuthStatus () {
    const { uid, email } = this._firebaseUser() || {}
    authState.user = appState.app ? new User({ id: uid, email }) : new User()
    authState.isAuthenticated = appState.app ? this.isAuthenticated() : false

    if (authState.isAuthenticated) {
      appState.state = C.READY
    } else {
      appState.state = C.NEEDS_AUTH
    }
  }

  login (email, password) {
    authState.attemptingLogin = true
    authState.loginFailed = false

    firebase.signIn(email, password)
    .then(action('login:succeeded', () => {
      authState.attemptingLogin = false
      authState.loginFailed = false
      this._updateAuthStatus()
    }))
    .catch(action('login:failed', () => {
      authState.attemptingLogin = false
      authState.loginFailed = true
    }))
  }

  logout () {
    firebase.signOut().then(action('logged:out', () => {
      authState.attemptingLogout = false
      this._updateAuthStatus()
    }))
  }

  _firebaseUser () {
    return firebase.getCurrentUser()
  }
}

export default new Auth()
