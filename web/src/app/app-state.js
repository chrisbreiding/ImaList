import { action, observable } from 'mobx'

import auth from '../auth/auth'
import C from '../data/constants'
import firebase from '../data/firebase'
import localStore from '../data/local-store'

class AppState {
  @observable.ref app = null
  @observable appName = localStore.get('appName') || 'imalist'
  @observable apiKey = localStore.get('apiKey')
  @observable attemptingClearCompleted = false
  @observable bulkAddingItems = false
  @observable editingItemId = null
  @observable firebaseApp = null
  @observable loadingData = false
  @observable showingFirebaseSettings = false
  @observable state = C.INITIALIZING_FIREBASE
  @observable viewingSettings = false

  initializeFirebaseApp () {
    this.app = firebase.init(this.appName, this.apiKey)

    if (this.app) {
      this.state = C.CONFIRMING_AUTH
      try {
        auth.listenForChange()
      } catch (e) {
        this.state = C.NEEDS_FIREBASE_CONFIG
      }
    } else {
      this.state = C.NEEDS_FIREBASE_CONFIG
    }
  }

  updateFirebaseSettings (appName, apiKey) {
    if (appName !== this.appName || apiKey !== this.apiKey) {
      localStore.set({ appName, apiKey })
      this.appName = appName
      this.apiKey = apiKey
      this.initializeFirebaseApp()
    }
    this.showingFirebaseSettings = false
  }
}

export default new AppState()
