import _ from 'lodash';
import C from '../data/constants';
import localStore from '../data/local-store';

export default function (state = {
  appName: localStore.get('appName') || 'imalist',
  attemptingClearCompleted: false,
  attemptingRemoveList: false,
  bulkAddItems: false,
  editItemId: null,
  editListId: null,
  loadingData: false,
  selectedListId: localStore.get('selectedListId') || null,
  showItems: localStore.get('showItems') || false,
}, action = {}) {
  switch (action.type) {
    case C.ATTEMPT_CLEAR_COMPLETED:
      return _.extend({}, state, {
        attemptingClearCompleted: action.clearCompleted
      });
    case C.ATTEMPT_REMOVE_LIST:
      return _.extend({}, state, {
        attemptingRemoveList: action.listId
      });
    case C.BULK_ADD_ITEMS:
      return _.extend({}, state, {
        bulkAddItems: action.bulkAddItems
      });
    case C.EDIT_LIST:
      return _.extend({}, state, {
        editListId: action.listId
      });
    case C.EDIT_ITEM:
      return _.extend({}, state, {
        editItemId: action.itemId
      });
    case C.LOADING_DATA:
      return _.extend({}, state, {
        loadingData: action.loadingData
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
    case C.UPDATE_APP_NAME:
      return _.extend({}, state, {
        appName: action.appName
      });
    default:
      return state;
  }
};
