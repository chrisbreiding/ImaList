import { connect } from 'react-redux';
import React, { Component } from 'react';

import auth from '../login/auth';
import firebase from '../data/firebase'
import C from '../data/constants'
import { updateAppState, updateFirebaseApp } from './app-actions'

import App from  './app';
import Login from  '../login/login';

class Root extends Component {
  componentWillMount () {
    this._checkApp()
  }

  componentDidUpdate (prevProps) {
    const { appName, apiKey } = this.props.app
    if (appName !== prevProps.app.appName || apiKey !== prevProps.app.apiKey) {
      this._checkApp()
    }
  }

  _checkApp () {
    const { appName, apiKey, firebaseApp } = this.props.app
    const app = firebase.init(firebaseApp, appName, apiKey)
    auth.init(this.props.dispatch);
    if (app) {
      this.props.dispatch(updateFirebaseApp(app))
    } else {
      this.props.dispatch(updateAppState(C.NEEDS_FIREBASE_CONFIG))
    }
  }

  render () {
    switch (this.props.app.state) {
      case C.NEEDS_INITIALIZATION:
      case C.NEEDS_FIREBASE_CONFIG:
      case C.NEEDS_AUTH:
        return <Login />
      default:
        return <App />
    }
  }
}

export default connect(({ app }) => ({ app }))(Root);
