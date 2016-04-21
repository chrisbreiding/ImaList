import C from '../data/constants';
import getFirebaseRef from '../data/firebase';
import localStore from '../data/local-store';

export function updateAppName (appName) {
  return (dispatch) => {
    localStore.set('appName', appName);
    dispatch({ type: C.UPDATE_APP_NAME, appName });
  };
}

function didUpdateLists (lists) {
  return { type: C.LISTS_UPDATED, lists };
}

export function listen (dispatch) {
  dispatch({ type: C.LOADING_DATA, loadingData: true });

  getFirebaseRef().on('child_added', (childSnapshot) => {
    dispatch(didUpdateLists(childSnapshot.val()));
  });

  getFirebaseRef().on('child_changed', (childSnapshot) => {
    dispatch(didUpdateLists(childSnapshot.val()));
  });

  getFirebaseRef().on('child_removed', (childSnapshot) => {
    if (childSnapshot.key() === 'lists') {
      dispatch(didUpdateLists({}));
    }
  });

  getFirebaseRef().on('value', () => {
    dispatch({ type: C.LOADING_DATA, loadingData: false });
  });
}

export function stopListening () {
  getFirebaseRef().off();
}
