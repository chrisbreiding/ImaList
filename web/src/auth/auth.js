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
    return this.usersApi.fetchUsersData().then(this._setUserPasscode)
  }

  listenForUserDataChanges () {
    this.usersApi.listen({
      onUpdate: this._setUserPasscode,
    })
  }

  @action _setUserPasscode = (users) => {
    const user = users && users[authState.user.id]
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
    firebase.getAuth().onAuthStateChanged(action('auth:state:changed', () => {
      this._updateAuthStatus()
      if (authState.isAuthenticated) {
        appState.state = C.READY
      } else {
        appState.state = C.NEEDS_AUTH
      }
    }))
  }

  _updateAuthStatus () {
    const { uid, email } = this._firebaseUser() || {}
    authState.user = appState.app ? new User({ id: uid, email }) : new User()
    authState.isAuthenticated = appState.app ? this.isAuthenticated() : false
  }

  login (email, password) {
    authState.attemptingLogin = true
    authState.loginFailed = false

    firebase.getAuth().signInWithEmailAndPassword(email, password)
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
    firebase.getAuth().signOut().then(action('logged:out', () => {
      authState.attemptingLogout = false
      this._updateAuthStatus()
    }))
  }

  _firebaseUser () {
    return firebase.getAuth().currentUser
  }
}

export default new Auth()
