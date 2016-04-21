import _ from 'lodash';
import C from '../data/constants';
import firebaseRef from '../data/firebase';

function newOrder (list) {
  return list.items && Object.keys(list.items).length ?
    Math.max.apply(Math, _.map(list.items, 'order')) + 1 :
    0;
}

function newItem ({ order, type = 'todo', name = '' }) {
  return {
    order,
    type,
    name,
    isChecked: false,
  };
}

export function addItem (list, { type }) {
  return (dispatch) => {
    const order = newOrder(list);
    const newRef = firebaseRef.child(`lists/${list.id}/items`).push(newItem({ order, type }), () => {
      dispatch(editItem(newRef.key()));
    });
  };
}

export function attemptBulkAdd (bulkAddItems) {
  return { type: C.BULK_ADD_ITEMS, bulkAddItems };
}

export function bulkAdd (list, names) {
  return () => {
    const startingOrder = newOrder(list);
    _(names)
      .reject(name => !name.trim())
      .map((name, index) => newItem({ name, order: startingOrder + index }))
      .each(item => {
        firebaseRef.child(`lists/${list.id}/items`).push(item);
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
