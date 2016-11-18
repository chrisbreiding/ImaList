import { action, computed, observable } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

import auth from './auth'
import authState from './auth-state'
import C from '../data/constants'
import Modal from '../modal/modal'
import PasscodeInput from './passcode-input'

@observer
class Passcode extends Component {
  @observable passcode = ''
  @observable error = ''

  @computed get isValid () {
    return this.passcode.length === 4
  }

  render () {
    return (
      <Modal className='passcode' isShowing={true}>
        <form onSubmit={this._submit}>
          <label>{this._message()}</label>
          <PasscodeInput
            ref='passcode'
            className='passcode-input'
            type='tel'
            value={this.passcode}
            onChange={this._updatePasscode}
          />
          <p className='error'>{this.error}</p>
          <div className='actions'>
            <button className='submit' disabled={!this.isValid}>
              {this._button()}
            </button>
            <button className='cancel' onClick={this._cancel}>Cancel</button>
          </div>
        </form>
      </Modal>
    )
  }

  componentDidMount () {
    this.refs.passcode.focus()
  }

  _message () {
    return authState.user.hasPasscode ? 'Enter your passcode' : 'Set a passcode'
  }

  _button () {
    return authState.user.hasPasscode ? 'Submit' : 'Set passcode'
  }

  @action _updatePasscode = (passcode) => {
    if (this.passcode !== passcode) {
      this.error = ''
      this.passcode = passcode
    }
  }

  @action _cancel = (e) => {
    e.preventDefault()
    authState.passcodeNeeded = false
    authState.onPasscodeCancel()
  }

  @action _submit = (e) => {
    e.preventDefault()

    if (!this.isValid) return

    if (authState.user.hasPasscode) {
      if (!auth.matchesUserPasscode(this.passcode)) {
        this.error = 'Passcode incorrect'
        this.refs.passcode.focus()
        return
      }
    } else {
      auth.updatePasscode(this.passcode)
    }

    authState.passcodeNeeded = false
    authState.onPasscodeSubmit()
  }
}

export default Passcode
