import C from '../data/constants';
import firebaseRef from '../data/firebase';

function didUpdateLists (lists) {
  return { type: C.LISTS_UPDATED, lists };
}

export function listen (dispatch) {
  dispatch({ type: C.LOADING_DATA, loadingData: true });

  firebaseRef.on('child_added', (childSnapshot) => {
    dispatch(didUpdateLists(childSnapshot.val()));
  });

  firebaseRef.on('child_changed', (childSnapshot) => {
    dispatch(didUpdateLists(childSnapshot.val()));
  });

  firebaseRef.on('child_removed', (childSnapshot) => {
    if (childSnapshot.key() === 'lists') {
      dispatch(didUpdateLists({}));
    }
  });

  firebaseRef.on('value', () => {
    dispatch({ type: C.LOADING_DATA, loadingData: false });
  });
}

export function stopListening () {
  firebaseRef.off();
}
