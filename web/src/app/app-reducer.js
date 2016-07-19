import _ from 'lodash';
import C from '../data/constants';
import localStore from '../data/local-store';

export default function (state = {
  appName: localStore.get('appName') || 'imalist',
  apiKey: localStore.get('apiKey'),
  attemptingClearCompleted: false,
  attemptingRemoveList: false,
  bulkAddItems: false,
  editItemId: null,
  editListId: null,
  firebaseApp: null,
  loadingData: false,
  selectedListId: localStore.get('selectedListId') || null,
  showingItems: localStore.get('showingItems') || false,
  showingFirebaseSettings: false,
  state: C.NEEDS_INITIALIZATION,
}, action = {}) {
  switch (action.type) {
    case C.ATTEMPT_CLEAR_COMPLETED:
      return _.extend({}, state, {
        attemptingClearCompleted: action.clearCompleted,
      });
    case C.ATTEMPT_REMOVE_LIST:
      return _.extend({}, state, {
        attemptingRemoveList: action.listId,
      });
    case C.BULK_ADD_ITEMS:
      return _.extend({}, state, {
        bulkAddItems: action.bulkAddItems,
      });
    case C.EDIT_LIST:
      return _.extend({}, state, {
        editListId: action.listId,
      });
    case C.EDIT_ITEM:
      return _.extend({}, state, {
        editItemId: action.itemId,
      });
    case C.LOADING_DATA:
      return _.extend({}, state, {
        loadingData: action.loadingData,
      });
    case C.SELECT_LIST:
      return _.extend({}, state, {
        editListId: null,
        selectedListId: action.listId,
      });
    case C.SHOW_ITEMS:
      return _.extend({}, state, {
        showingItems: action.showingItems,
      });
    case C.SHOW_SETTINGS:
      return _.extend({}, state, {
        showFirebaseSettings: action.showFirebaseSettings,
      });
    case C.UPDATE_FIREBASE_APP:
      return _.extend({}, state, {
        firebaseApp: action.firebaseApp,
        state: C.NEEDS_AUTH,
      });
    case C.UPDATE_FIREBASE_SETTINGS:
      return _.extend({}, state, {
        appName: action.appName,
        apiKey: action.apiKey,
        state: C.NEEDS_INITIALIZATION,
      });
    case C.UPDATE_APP_STATE:
      return _.extend({}, state, {
        state: action.state,
      });
    case C.UPDATE_AUTH_STATUS:
      return _.extend({}, state, {
        state: action.isAuthenticated ? C.READY : C.NEEDS_AUTH,
      });
    default:
      return state;
  }
}
