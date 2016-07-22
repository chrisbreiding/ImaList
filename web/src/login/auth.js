import { action } from 'mobx'

import appState from '../app/app-state'
import authState from './auth-state'
import C from '../data/constants'
import firebase from '../data/firebase'

class Auth {
  isAuthenticated () {
    return !!this._currentUser()
  }

  userEmail () {
    const user = this._currentUser()
    return user ? user.email : null
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
    authState.userEmail = appState.app ? this.userEmail() : null
    authState.isAuthenticated = appState.app ? this.isAuthenticated() : false
  }

  login (email, password) {
    authState.attemptingLogin = true

    firebase.getAuth().signInWithEmailAndPassword(email, password)
    .then(action('login:succeeded', () => {
      authState.attemptingLogin = false
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

  _currentUser () {
    return firebase.getAuth().currentUser
  }
}

export default new Auth()
