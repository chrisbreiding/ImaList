import auth from './auth';
import C from '../data/constants';

export function updateAuthStatus (app) {
  return {
    type: C.UPDATE_AUTH_STATUS,
    email: app ? auth.userEmail(app) : null,
    isAuthenticated: app ? auth.isAuthenticated(app) : false,
  };
}

export function login (app, email, password) {
  return (dispatch) => {
    dispatch({ type: C.ATTEMPT_LOGIN });

    auth.login(app, email, password)
    .then(() => {
      dispatch(updateAuthStatus(app));
    })
    .catch(() => {
      dispatch({ type: C.LOGIN_FAILED });
    });
  };
}

export function attemptLogout (attemptingLogout) {
  return { type: C.ATTEMPT_LOGOUT, attemptingLogout };
}

export function logout (app) {
  return () => {
    auth.logout(app);
  };
}
