import firebase from 'firebase';
import { updateAppState } from '../app/app-actions'
import C from './constants'
import { observeStore, store } from './store';

let app;

observeStore('app.app', (appData) => {
  if (app) app.delete()

  try {
    app = firebase.initializeApp({
      apiKey: appData.apiKey,
      authDomain: `${appData.name}.firebaseapp.com`,
      databaseURL: `https://${appData.name}.firebaseio.com`,
      storageBucket: `${appData.name}.appspot.com`,
    }, appData.name);
    store.dispatch(updateAppState(C.NEEDS_AUTH))
  } catch (e) {
    store.dispatch(updateAppState(C.NEEDS_FIREBASE_CONFIG))
  }
});

function getFirebaseAuth () {
  return app.auth();
}

function getFirebaseRef () {
  return app.database().ref();
}

export {
  getFirebaseAuth,
  getFirebaseRef,
}
