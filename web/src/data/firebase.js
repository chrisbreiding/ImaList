import firebase from 'firebase'

import appState from '../app/app-state'

function init (appName, apiKey) {
  if (appState.app) appState.app.delete()

  try {
    return firebase.initializeApp({
      apiKey,
      authDomain: `${appName}.firebaseapp.com`,
      databaseURL: `https://${appName}.firebaseio.com`,
      storageBucket: `${appName}.appspot.com`,
    }, appName)
  } catch (e) {
    return null
  }
}

function getAuth () {
  return appState.app.auth()
}

function getRef () {
  return appState.app.database().ref()
}

export default {
  getAuth,
  getRef,
  init,
}
