import React, { createClass } from 'react';
import { findDOMNode } from 'react-dom';

export default createClass({
  displayName: 'Login',

  getInitialState () {
    return {
      attemptingLogin: false,
      loginFailed: false,
    };
  },

  render () {
    return (
      <div className='login'>
        <header>
          <h1>Please Log In</h1>
          {this.state.loginFailed ? <p className='error'>Login failed. Please try again.</p> : null}
        </header>
        <form onSubmit={this._attemptLogin}>
          <fieldset>
            <label>Email</label>
            <input ref='email' type='email' />
          </fieldset>
          <fieldset>
            <label>Password</label>
            <input ref='password' type='password' />
          </fieldset>
          <fieldset>
            {this.state.attemptingLogin ?
              <span><i className='fa fa-spinner fa-spin'></i></span> :
              <button>Log In</button>}
          </fieldset>
        </form>
      </div>
    );
  },

  _attemptLogin (e) {
    e.preventDefault();

    const email =  findDOMNode(this.refs.email).value;
    const password =  findDOMNode(this.refs.password).value;

    this.setState({ attemptingLogin: true }, () => {
      this.props.auth.login(email, password).then(function(didSucceed) {
        if (didSucceed) {
          return this.props.onLogin(email);
        } else {
          return this.setState({
            attemptingLogin: false,
            loginFailed: true
          });
        }
      });
    });
  },
});
