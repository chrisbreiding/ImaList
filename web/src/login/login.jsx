import { action } from 'mobx'
import { observer } from 'mobx-react'
import React from 'react'

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

  return (
    <div className='login'>
      <header>
        <h1>Please Log In</h1>
      </header>
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
        <fieldset>
          {authState.attemptingLogin ?
            <span><i className='fa fa-spinner fa-spin'></i></span> :
            <button>Log In</button>}
        </fieldset>
      </form>
      <button>
        <i className='fa fa-cog'></i> Firebase Settings
      </button>
      <Settings />
    </div>
  )
})

export default Login
