import { action } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

import appState from './app-state'
import C from '../data/constants'

import App from  './app'
import Login from  '../auth/login'

const Loading = () => (
  <div className='app-loading'>
    <header className='fixed'></header>
    <p className='no-items'>
      <i className='fa fa-hourglass-end fa-spin'></i> Loading...
    </p>
  </div>
)

@observer
class Root extends Component {
  componentWillMount () {
    action('root:will:mount', () => {
      appState.initializeFirebaseApp()
    })()
  }

  render () {
    switch (appState.state) {
      case C.INITIALIZING_FIREBASE:
      case C.CONFIRMING_AUTH:
        return <Loading />
      case C.NEEDS_FIREBASE_CONFIG:
      case C.NEEDS_AUTH:
        return <Login />
      default:
        return <App />
    }
  }
}

export default Root
