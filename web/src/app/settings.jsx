import { action, computed, observable } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

import appState from './app-state'
import auth from '../auth/auth'
import authState from '../auth/auth-state'
import Modal from '../modal/modal'
import PasscodeInput from '../auth/passcode-input'

@observer
class Settings extends Component {
  @observable oldPasscode = ''
  @observable newPasscode = ''
  @observable error = ''

  @computed get isValid () {
    if (authState.user.hasPasscode) {
      return this.oldPasscode.length === 4 && this.newPasscode.length === 4
    } else {
      return this.newPasscode.length === 4
    }
  }

  render () {
    return (
      <Modal className='app-settings' isShowing={true}>
        <header className='fixed'>
          <h1>Settings</h1>
        </header>
        <form onSubmit={this._submit}>
          {this._oldPasscode()}
          <fieldset>
            <label>{authState.user.hasPasscode ? 'New passcode' : 'Passcode'}</label>
            <PasscodeInput
              ref='newPasscode'
              value={this.newPasscode}
              onChange={this._updateNewPasscode}
            />
          </fieldset>
          <div className='actions'>
            <button className='submit' disabled={!this.isValid}>Save</button>
            <button className='cancel' onClick={this._cancel}>Cancel</button>
          </div>
        </form>
      </Modal>
    )
  }

  _oldPasscode () {
    if (!authState.user.hasPasscode) return null

    return (
      <fieldset>
        <label>Old passcode</label>
        <PasscodeInput
          ref='oldPasscode'
          value={this.oldPasscode}
          onChange={this._updateOldPasscode}
        />
        <p className='error'>{this.error}</p>
      </fieldset>
    )
  }

  componentDidMount () {
    this.refs[authState.user.hasPasscode ? 'oldPasscode' : 'newPasscode'].focus()
  }

  @action _updateOldPasscode = (passcode) => {
    this.oldPasscode = passcode
  }

  @action _updateNewPasscode = (passcode) => {
    this.newPasscode = passcode
  }

  @action _cancel = (e) => {
    e.preventDefault()
    appState.viewingSettings = false
  }

  @action _submit = (e) => {
    e.preventDefault()

    if (!this.isValid) return

    if (authState.user.hasPasscode && !auth.matchesUserPasscode(this.oldPasscode)) {
      this.error = 'Passcode incorrect'
      this.refs.oldPasscode.focus()
      return
    }

    auth.updatePasscode(this.newPasscode)
    appState.viewingSettings = false
  }
}

export default Settings
