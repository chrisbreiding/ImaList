import firebase from 'firebase';

function init (prevApp, appName, apiKey) {
  if (prevApp) prevApp.delete()

  try {
    const app = firebase.initializeApp({
      apiKey,
      authDomain: `${appName}.firebaseapp.com`,
      databaseURL: `https://${appName}.firebaseio.com`,
      storageBucket: `${appName}.appspot.com`,
    }, appName);
    return app
  } catch (e) {
    return null
  }
}

function getAuth (app) {
  return app.auth();
}

function getRef (app) {
  return app.database().ref();
}

export default {
  getAuth,
  getRef,
  init,
}
