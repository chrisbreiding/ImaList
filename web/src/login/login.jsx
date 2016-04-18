import { connect } from 'react-redux';
import React from 'react';
import { findDOMNode } from 'react-dom';
import { login } from './auth-actions';

function Login ({ dispatch, auth }) {
  let email, password;

  function attemptLogin (e) {
    e.preventDefault();

    dispatch(login(
      findDOMNode(email).value,
      findDOMNode(password).value
    ));
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
          <input ref={node => email = node} type='email' />
        </fieldset>
        <fieldset>
          <label>Password</label>
          <input ref={node => password = node} type='password' />
        </fieldset>
        <fieldset>
          {auth.attemptingLogin ?
            <span><i className='fa fa-spinner fa-spin'></i></span> :
            <button>Log In</button>}
        </fieldset>
      </form>
    </div>
  );
}

export default connect(({ auth }) => ({ auth }))(Login);
