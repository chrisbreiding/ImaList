import auth from '../login/auth'
import C from '../data/constants';
import firebase from '../data/firebase';
import localStore from '../data/local-store';

export function showFirebaseSettings (showingFirebaseSettings) {
  return { type: C.SHOW_FIREBASE_SETTINGS, showingFirebaseSettings };
}

export function updateFirebaseSettings (appName, apiKey) {
  return (dispatch) => {
    localStore.set('appName', appName);
    localStore.set('apiKey', apiKey);
    dispatch({ type: C.UPDATE_FIREBASE_SETTINGS, appName, apiKey });
  };
}

export function updateFirebaseApp (firebaseApp) {
  return (dispatch) => {
    dispatch({ type: C.UPDATE_FIREBASE_APP, firebaseApp });
    auth.listenForChange(firebaseApp)
  };
}

function didUpdateLists (lists) {
  return { type: C.LISTS_UPDATED, lists };
}

export function listen (app, dispatch) {
  dispatch({ type: C.LOADING_DATA, loadingData: true });

  firebase.getRef(app).on('child_added', (childSnapshot) => {
    dispatch(didUpdateLists(childSnapshot.val()));
  });

  firebase.getRef(app).on('child_changed', (childSnapshot) => {
    dispatch(didUpdateLists(childSnapshot.val()));
  });

  firebase.getRef(app).on('child_removed', (childSnapshot) => {
    if (childSnapshot.key === 'lists') {
      dispatch(didUpdateLists({}));
    }
  });

  firebase.getRef(app).on('value', () => {
    dispatch({ type: C.LOADING_DATA, loadingData: false });
  });
}

export function stopListening (app) {
  firebase.getRef(app).off();
}

export function updateAppState (state) {
  return {
    type: C.UPDATE_APP_STATE,
    state,
  }
}
