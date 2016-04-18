import _ from 'lodash';
import C from '../data/constants';

export default function (state = {
  attemptingLogin: false,
  isAuthenticated: false,
  loginFailed: false,
  email: null,
  attemptingLogout: false,
}, action = {}) {
  switch (action.type) {
    case C.ATTEMPT_LOGIN:
      return _.extend({}, state, {
        attemptingLogin: true,
        loginFailed: false,
      });
    case C.LOGIN_FAILED:
      return _.extend({}, state, {
        attemptingLogin: false,
        loginFailed: true,
      });
    case C.UPDATE_AUTH_STATUS:
      return _.extend({}, state, {
        attemptingLogin: false,
        attemptingLogout: false,
        email: action.email,
        isAuthenticated: action.isAuthenticated,
        loginFailed: false,
      });
    case C.ATTEMPT_LOGOUT:
      return _.extend({}, state, {
        attemptingLogout: action.attemptingLogout,
      });
    default:
      return state;
  }
};
