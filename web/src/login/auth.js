import firebaseRef from '../data/firebase';

export default {
  isAuthenticated () {
    return firebaseRef.getAuth() != null;
  },

  userEmail () {
    const auth = firebaseRef.getAuth();
    return auth && auth.password && auth.password.email;
  },

  onChange (callback) {
    firebaseRef.onAuth(() => callback(this.isAuthenticated()));
  },

  login (email, password, callback) {
    firebaseRef.authWithPassword({ email, password }, (err, authData) => {
      callback(authData != null);
    });
  },

  logout () {
    firebaseRef.unauth();
  },
};
