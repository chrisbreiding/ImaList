import { action } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

import appState from '../app/app-state'
import C from '../data/constants'

import Modal from '../modal/modal'

@observer
class Settings extends Component {
  componentDidUpdate () {
    if (appState.showingFirebaseSettings) {
      this.refs.appName.focus()
    }
  }

  render () {
    return (
      <Modal className='settings modal-form' isShowing={this._shouldShowSettings()}>
        <header>
          <h1>Firebase Settings</h1>
        </header>
        <form onSubmit={this._updateFirebaseSettings}>
          <fieldset>
            <label>App Name</label>
            <input
              ref='appName'
              placeholder='App Name'
              defaultValue={appState.appName}
            />
          </fieldset>
          <fieldset>
            <label>API Key</label>
            <input
              ref='apiKey'
              placeholder='API Key'
              defaultValue={appState.apiKey}
            />
          </fieldset>
          <fieldset>
            <button>Save</button>
          </fieldset>
        </form>
      </Modal>
    )
  }

  _shouldShowSettings () {
    return appState.state === C.NEEDS_FIREBASE_CONFIG || appState.showingFirebaseSettings
  }

  @action _updateFirebaseSettings = (e) => {
    e.preventDefault()
    appState.updateFirebaseSettings(this.refs.appName.value, this.refs.apiKey.value)
  }
}

export default Settings
