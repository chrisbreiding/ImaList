import RSVP from 'rsvp';

export default class Auth {
  constructor (ref) {
    this._ref = ref;
  }

  isAuthenticated () {
    return this._ref.getAuth() != null;
  }

  userEmail () {
    return this._ref.getAuth().password.email;
  }

  onAuthChange (callback) {
    this._ref.onAuth(callback);
  }

  login (email, password) {
    return new RSVP.Promise((resolve) => {
      this._ref.authWithPassword({ email, password }, (err, authData) => {
        resolve(authData != null);
      });
    });
  }

  logout () {
    this._ref.unauth();
  }
};
