import _ from 'lodash';
import C from '../data/constants';

export default function (state = {
  attemptingLogin: false,
  attemptingLogout: false,
  email: null,
  isAuthenticated: false,
  loginFailed: false,
  showingSettings: false,
}, action = {}) {
  switch (action.type) {
    case C.ATTEMPT_LOGIN:
      return _.extend({}, state, {
        attemptingLogin: true,
        loginFailed: false,
      });
    case C.ATTEMPT_LOGOUT:
      return _.extend({}, state, {
        attemptingLogout: action.attemptingLogout,
      });
    case C.LOGIN_FAILED:
      return _.extend({}, state, {
        attemptingLogin: false,
        loginFailed: true,
      });
    case C.SHOW_SETTINGS:
      return _.extend({}, state, {
        showingSettings: action.showingSettings,
      });
    case C.UPDATE_AUTH_STATUS:
      return _.extend({}, state, {
        attemptingLogin: false,
        attemptingLogout: false,
        email: action.email,
        isAuthenticated: action.isAuthenticated,
        loginFailed: false,
      });
    default:
      return state;
  }
};
