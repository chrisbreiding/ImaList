import _ from 'lodash';
import C from '../data/constants';
import localStore from '../data/local-store';

export default function (state = {
  attemptingClearCompleted: false,
  attemptingRemoveList: false,
  editItemId: null,
  editListId: null,
  loadingData: false,
  selectedListId: localStore.get('selectedListId') || null,
  showItems: localStore.get('showItems') || false,
}, action = {}) {
  switch (action.type) {
    case C.EDIT_LIST:
      return _.extend({}, state, {
        editListId: action.listId
      });
    case C.SELECT_LIST:
      return _.extend({}, state, {
        editListId: null,
        selectedListId: action.listId
      });
    case C.SHOW_ITEMS:
      return _.extend({}, state, {
        showItems: action.showItems
      });
    case C.LOADING_DATA:
      return _.extend({}, state, {
        loadingData: action.loadingData
      });
    case C.ATTEMPT_REMOVE_LIST:
      return _.extend({}, state, {
        attemptingRemoveList: action.listId
      });
    case C.EDIT_ITEM:
      return _.extend({}, state, {
        editItemId: action.itemId
      });
    case C.ATTEMPT_CLEAR_COMPLETED:
      return _.extend({}, state, {
        attemptingClearCompleted: action.clearCompleted
      });
    default:
      return state;
  }
};