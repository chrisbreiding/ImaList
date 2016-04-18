import { connect } from 'react-redux';
import React, { Component } from 'react';

import auth from '../login/auth';
import { updateAuthStatus } from '../login/auth-actions';

import App from  './app';
import Login from  '../login/login';

class Root extends Component {
  componentWillMount () {
    auth.onChange(() => this.props.dispatch(updateAuthStatus()));
  }

  render () {
    return this.props.auth.isAuthenticated ? <App /> : <Login />;
  }
}

export default connect(({ auth }) => ({ auth }))(Root);
