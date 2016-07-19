import { updateAuthStatus } from './auth-actions';
import firebase from '../data/firebase'

export default {
  init (dispatch) {
    this.dispatch = dispatch
  },

  isAuthenticated (app) {
    return !!this._currentUser(app)
  },

  userEmail (app) {
    const user = this._currentUser(app);
    return user ? user.email : null;
  },

  listenForChange (app) {
    firebase.getAuth(app).onAuthStateChanged(() => {
      this.dispatch(updateAuthStatus(app))
    })
  },

  login (app, email, password) {
    return firebase.getAuth(app).signInWithEmailAndPassword(email, password);
  },

  logout (app) {
    firebase.getAuth(app).signOut().then(() => {
      this.dispatch(updateAuthStatus(app))
    });
  },

  _currentUser (app) {
    return firebase.getAuth(app).currentUser;
  },
};
