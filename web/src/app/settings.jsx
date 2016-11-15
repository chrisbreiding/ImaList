import { action, computed, observable } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

import appState from './app-state'
import auth from '../auth/auth'
import authState from '../auth/auth-state'
import Modal from '../modal/modal'

@observer
class Settings extends Component {
  @observable oldPasscode = ''
  @observable newPasscode = ''
  @observable error = ''

  @computed get isValid () {
    return this.oldPasscode.length === 4 && this.newPasscode.length === 4
  }

  render () {
    return (
      <Modal className='app-settings' isShowing={true}>
        <header className='fixed'>
          <h1>Settings</h1>
        </header>
        <form onSubmit={this._submit}>
          <label>Old passcode</label>
          <input
            ref='oldPasscode'
            type='tel'
            value={this.oldPasscode}
            onChange={this._updateOldPasscode}
          />
          <p className='error'>{this.error}</p>
          <label>New passcode</label>
          <input
            ref='newPasscode'
            type='tel'
            value={this.newPasscode}
            onChange={this._updateNewPasscode}
          />
          <div className='actions'>
            <button className='submit' disabled={!this.isValid}>Save</button>
            <button className='cancel' onClick={this._cancel}>Cancel</button>
          </div>
        </form>
      </Modal>
    )
  }

  componentDidMount () {
    this.refs.oldPasscode.focus()
  }

  @action _updateOldPasscode = (e) => {
    const value = (e.target.value).toString()
    if (value.length <= 4) {
      this.oldPasscode = value
    }
  }

  @action _updateNewPasscode = (e) => {
    const value = (e.target.value).toString()
    if (value.length <= 4) {
      this.newPasscode = value
    }
  }

  @action _cancel = (e) => {
    e.preventDefault()
    appState.viewingSettings = false
  }

  @action _submit = (e) => {
    e.preventDefault()

    if (!this.isValid) return

    if (authState.user.passcode !== this.oldPasscode) {
      this.error = 'Passcode incorrect'
      return
    }

    auth.updatePasscode(this.newPasscode)
    appState.viewingSettings = false
  }
}

export default Settings
