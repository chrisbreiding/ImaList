import { action } from 'mobx'
import { observer } from 'mobx-react'
import React from 'react'

import appState from '../app/app-state'
import authState from './auth-state'
import auth from './auth'

import Settings from './settings'

const Login = observer(() => {
  let email
  let password

  const attemptLogin = action('attempt:login', (e) => {
    e.preventDefault()
    auth.login(email.value, password.value)
  })

  const showFirebaseSettings = action('show:firebase:settings', () => {
    appState.showingFirebaseSettings = true
  })

  return (
    <div className='login'>
      <header>
        <h1>Please Log In</h1>
      </header>
      <div className='container'>
        {authState.loginFailed ? <p className='error'>Login failed. Please try again.</p> : null}
        <form onSubmit={attemptLogin}>
          <fieldset>
            <label>Email</label>
            <input ref={(node) => email = node} type='email' />
          </fieldset>
          <fieldset>
            <label>Password</label>
            <input ref={(node) => password = node} type='password' />
          </fieldset>
          <div className='actions'>
            {authState.attemptingLogin ?
              <span><i className='fa fa-spinner fa-spin'></i></span> :
              <button>Log In</button>}
          </div>
        </form>
      </div>
      <footer>
        <button onClick={showFirebaseSettings}>
          <i className='fa fa-cog'></i>
        </button>
      </footer>
      <Settings />
    </div>
  )
})

export default Login
