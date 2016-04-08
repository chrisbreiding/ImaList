import FastClick from  'fastclick';
import Firebase from 'firebase';
import React from  'react';
import ReactDOM from 'react-dom';

import App from  './app/app';
import Auth from './login/auth';
import Login from  './login/login';

new FastClick(document.body);

const appName = localStorage.appName || 'imalist';
const FIREBASE_URL = `https://${appName}.firebaseio.com`;

const ref = new Firebase(FIREBASE_URL);
const auth = new Auth(ref);

const logout = () => {
  auth.logout();
  render();
};

const render = (userEmail) => {
  let component;
  if (auth.isAuthenticated()) {
    component = <App
      firebaseRef={ref}
      onLogout={logout}
      userEmail={userEmail || auth.userEmail()}
    />;
  } else {
    component = <Login
      auth={auth}
      onLogin={render}
    />;
  }
  ReactDOM.render(component, document.getElementById('app'));
};

auth.onAuthChange(render);

render();
