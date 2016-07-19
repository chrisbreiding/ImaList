import React from 'react';
import { connect } from 'react-redux';

import { login } from './auth-actions';

import Settings from './settings';

const Login = ({ app, auth, dispatch }) => {
  let email;
  let password;

  function attemptLogin (e) {
    e.preventDefault();
    dispatch(login(app.firebaseApp, email.value, password.value));
  }

  return (
    <div className='login'>
      <header>
        <h1>Please Log In</h1>
      </header>
      {auth.loginFailed ? <p className='error'>Login failed. Please try again.</p> : null}
      <form onSubmit={attemptLogin}>
        <fieldset>
          <label>Email</label>
          <input ref={(node) => email = node} type='email' />
        </fieldset>
        <fieldset>
          <label>Password</label>
          <input ref={(node) => password = node} type='password' />
        </fieldset>
        <fieldset>
          {auth.attemptingLogin ?
            <span><i className='fa fa-spinner fa-spin'></i></span> :
            <button>Log In</button>}
        </fieldset>
      </form>
      <button>
        <i className='fa fa-cog'></i> Firebase Settings
      </button>
      <Settings />
    </div>
  );
}

export default connect(({ app, auth }) => ({ app, auth }))(Login);
