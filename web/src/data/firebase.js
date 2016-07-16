import firebase from 'firebase';
import { observeStore } from './store';

let app;

observeStore('app.app', (appData) => {
  app = firebase.initializeApp({
    apiKey: appData.apiKey,
    authDomain: `${appData.name}.firebaseapp.com`,
    databaseURL: `https://${appData.name}.firebaseio.com`,
    storageBucket: `${appData.name}.appspot.com`,
  }, appData.name);
});

function getFirebaseAuth () {
  return firebase.auth(app);
}

function getFirebaseRef () {
  return firebase.database(app).ref();
}

export {
  getFirebaseAuth,
  getFirebaseRef,
}
