import _ from 'lodash';
import C from '../data/constants';
import firebase from '../data/firebase';

function newOrder (list) {
  return list.items && Object.keys(list.items).length ?
    Math.max(..._.map(list.items, 'order')) + 1 :
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

export function addItem (app, list, { type }) {
  return (dispatch) => {
    const order = newOrder(list);
    const newRef = firebase.getRef(app).child(`lists/${list.id}/items`).push(newItem({ order, type }), () => {
      dispatch(editItem(newRef.key));
    });
  };
}

export function attemptBulkAdd (bulkAddItems) {
  return { type: C.BULK_ADD_ITEMS, bulkAddItems };
}

export function bulkAdd (app, list, names) {
  return () => {
    const startingOrder = newOrder(list);
    _(names)
      .reject((name) => !name.trim())
      .map((name, index) => newItem({ name, order: startingOrder + index }))
      .each((item) => {
        firebase.getRef(app).child(`lists/${list.id}/items`).push(item);
      });
  };
}

export function editItem (app, itemId) {
  return { type: C.EDIT_ITEM, itemId };
}

export function updateItem (app, list, item) {
  return () => {
    firebase.getRef(app).child(`lists/${list.id}/items/${item.id}`).update(item);
  };
}

export function removeItem (app, list, id) {
  return () => {
    firebase.getRef(app).child(`lists/${list.id}/items/${id}`).remove();
  };
}

export function attemptClearCompleted (clearCompleted = true) {
  return { type: C.ATTEMPT_CLEAR_COMPLETED, clearCompleted };
}

export function clearCompleted (app, list) {
  return (dispatch, getState) => {
    const items = getState().lists[list.id].items;
    _.each(items, (item) => {
      if (item.isChecked) {
        firebase.getRef(app).child(`lists/${list.id}/items/${item.id}`).remove();
      }
    });
    dispatch(attemptClearCompleted(false));
  };
}
