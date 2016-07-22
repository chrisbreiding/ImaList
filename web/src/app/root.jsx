import { action, autorun } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

import appState from './app-state'
import auth from '../login/auth'
import firebase from '../data/firebase'
import C from '../data/constants'

import App from  './app'
import Login from  '../login/login'

@observer
class Root extends Component {
  componentWillMount () {
    autorun(() => {
      const { appName, apiKey } = appState
      const app = firebase.init(appName, apiKey)
      if (app) {
        action('app:initialized', () => {
          appState.app = app
          appState.state = C.NEEDS_AUTH
        })()
        auth.listenForChange()
      } else {
        action('app:initialization:failed', () => appState.state = C.NEEDS_FIREBASE_CONFIG)()
      }
    })
  }

  render () {
    switch (appState.state) {
      case C.NEEDS_INITIALIZATION:
      case C.NEEDS_FIREBASE_CONFIG:
      case C.NEEDS_AUTH:
        return <Login />
      default:
        return <App />
    }
  }
}

export default Root
