import { updateAuthStatus } from './auth-actions';
import { getFirebaseAuth } from '../data/firebase'

export default {
  init (dispatch) {
    this.dispatch = dispatch
  },

  isAuthenticated () {
    return !!this._currentUser()
  },

  userEmail () {
    const user = this._currentUser();
    return user && user.email;
  },

  listenForChange () {
    getFirebaseAuth().onAuthStateChanged(() => {
      this.dispatch(updateAuthStatus())
    })
  },

  login (email, password) {
    return getFirebaseAuth().signInWithEmailAndPassword(email, password);
  },

  logout () {
    getFirebaseAuth().signOut().then(() => {
      this.dispatch(updateAuthStatus())
    });
  },

  _currentUser () {
    return getFirebaseAuth().currentUser;
  },
};
