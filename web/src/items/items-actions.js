import _ from 'lodash';
import C from '../data/constants';
import firebaseRef from '../data/firebase';

function newItem ({ order, type = 'todo' }) {
  return {
    order,
    type,
    name: '',
    isChecked: false,
  };
}

export function addItem (list, { type }) {
  return (dispatch) => {
    const order = list.items && Object.keys(list.items).length ? Math.max.apply(Math, _.map(list.items, 'order')) + 1 : 0;
    const newRef = firebaseRef.child(`lists/${list.id}/items`).push(newItem({ order, type }), () => {
      dispatch(editItem(newRef.key()));
    });
  };
}

export function editItem (itemId) {
  return { type: C.EDIT_ITEM, itemId };
}

export function updateItem (list, item) {
  return () => {
    firebaseRef.child(`lists/${list.id}/items/${item.id}`).update(item);
  };
}

export function removeItem (list, id) {
  return () => {
    firebaseRef.child(`lists/${list.id}/items/${id}`).remove();
  };
}

export function attemptClearCompleted (clearCompleted = true) {
  return { type: C.ATTEMPT_CLEAR_COMPLETED, clearCompleted };
}

export function clearCompleted (list) {
  return (dispatch, getState) => {
    const items = getState().lists[list.id].items;
    _.each(items, item => {
      if (item.isChecked) {
        firebaseRef.child(`lists/${list.id}/items/${item.id}`).remove();
      }
    });
    dispatch(attemptClearCompleted(false));
  };
}
