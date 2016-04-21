import auth from './auth';
import C from '../data/constants';

export function updateAuthStatus () {
  return {
    type: C.UPDATE_AUTH_STATUS,
    email: auth.userEmail(),
    isAuthenticated: auth.isAuthenticated()
  };
}

export function login (email, password) {
  return (dispatch) => {
    dispatch({ type: C.ATTEMPT_LOGIN });

    auth.login(email, password, (didSucceed) => {
      if (didSucceed) {
        dispatch(updateAuthStatus(true));
      } else {
        dispatch({ type: C.LOGIN_FAILED });
      }
    });
  };
};

export function attemptLogout (attemptingLogout) {
  return { type: C.ATTEMPT_LOGOUT, attemptingLogout };
}

export function logout () {
  return () => {
    auth.logout();
  };
}

export function showSettings (showingSettings) {
  return { type: C.SHOW_SETTINGS, showingSettings };
}
