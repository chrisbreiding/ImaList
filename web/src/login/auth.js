import { updateAuthStatus } from './auth-actions';
import { getFirebaseAuth } from '../data/firebase'

let theDispatch

export default {
  isAuthenticated () {
    return !!this._currentUser()
  },

  userEmail () {
    const user = this._currentUser();
    return user && user.email;
  },

  listenForChange (dispatch) {
    theDispatch = dispatch
    getFirebaseAuth().onAuthStateChanged(() => dispatch(updateAuthStatus()))
  },

  login (email, password) {
    return getFirebaseAuth().signInWithEmailAndPassword(email, password);
  },

  logout () {
    getFirebaseAuth().signOut().then(() => {
      theDispatch(updateAuthStatus())
    });
  },

  _currentUser () {
    return getFirebaseAuth().currentUser;
  },
};
