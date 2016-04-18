import _ from 'lodash';
import C from '../data/constants';
import firebaseRef from '../data/firebase';
import localStore from '../data/local-store';

function newList ({ order, owner }) {
  return {
    order,
    owner,
    name: '',
    items: {},
    shared: false,
  };
}

export function selectList (listId = null) {
  localStore.set({
    selectedListId: listId,
    showItems: !!listId,
  });

  return (dispatch) => {
    if (listId) {
      dispatch({ type: C.SELECT_LIST, listId });
      dispatch({ type: C.SHOW_ITEMS, showItems: true });
    } else {
      dispatch({ type: C.SHOW_ITEMS, showItems: false });
    }
  };
}

export function addList (lists, email) {
  return (dispatch) => {
    const order = lists && Object.keys(lists).length ? Math.max.apply(Math, _.map(lists, 'order')) + 1 : 0;
    const newRef = firebaseRef.child('lists').push(newList({ order, owner: email }), () => {
      dispatch(editList(newRef.key()));
    });
  };
}

export function editList (listId) {
  return { type: C.EDIT_LIST, listId };
}

export function updateList (list) {
  return () => {
    firebaseRef.child(`lists/${list.id}`).update(list);
  };
}

export function attemptRemoveList (listId) {
  return { type: C.ATTEMPT_REMOVE_LIST, listId };
}

export function removeList (id) {
  return (dispatch) => {
    firebaseRef.child(`lists/${id}`).remove();
    dispatch(attemptRemoveList(false));
  };
}