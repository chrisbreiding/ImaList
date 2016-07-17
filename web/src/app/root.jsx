import { connect } from 'react-redux';
import React from 'react';

import App from  './app';
import Login from  '../login/login';

const Root = (props) => (
  props.auth.isAuthenticated ? <App /> : <Login />
);

export default connect(({ auth }) => ({ auth }))(Root);
