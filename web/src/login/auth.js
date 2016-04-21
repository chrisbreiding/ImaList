import { updateAuthStatus } from './auth-actions';
import getFirebaseRef from '../data/firebase';
import { observeStore } from '../data/store';

export default {
  isAuthenticated () {
    return this._firebaseRef.getAuth() != null;
  },

  userEmail () {
    const auth = this._firebaseRef.getAuth();
    return auth && auth.password && auth.password.email;
  },

  listenForChange (dispatch) {
    this._firebaseRef = getFirebaseRef();
    observeStore('app.appName', () => this._firebaseRefChanged(dispatch));
    this._firebaseRefChanged(dispatch);
  },

  _firebaseRefChanged (dispatch) {
    if (this._authChangeCallback) {
      this._firebaseRef.offAuth(this._authChangeCallback);
    }
    this._firebaseRef = getFirebaseRef();
    this._authChangeCallback = () => dispatch(updateAuthStatus());
    this._firebaseRef.onAuth(this._authChangeCallback);
  },

  login (email, password, callback) {
    this._firebaseRef.authWithPassword({ email, password }, (err, authData) => {
      callback(authData != null);
    });
  },

  logout () {
    this._firebaseRef.unauth();
  },
};
