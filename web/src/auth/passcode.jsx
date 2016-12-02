import { action, computed, observable } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

import auth from './auth'
import authState from './auth-state'
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
          <fieldset>
            <label>{this._message()}</label>
            <PasscodeInput
              ref='passcode'
              className='passcode-input'
              type='tel'
              value={this.passcode}
              onChange={this._updatePasscode}
            />
            <p className='error'>{this.error}</p>
          </fieldset>
          <div className='actions'>
            {this._submitButton()}
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

  _submitButton () {
    if (authState.user.hasPasscode) {
      return null
    } else {
      return (
        <button className='submit' disabled={!this.isValid}>
          Set Passcode
        </button>
      )
    }
  }

  @action _updatePasscode = (passcode) => {
    if (this.passcode !== passcode) {
      this.error = ''
      this.passcode = passcode
    }
    if (passcode.length === 4 && authState.user.hasPasscode) {
      this._submit()
    }
  }

  @action _cancel = (e) => {
    e.preventDefault()
    authState.passcodeNeeded = false
    authState.onPasscodeCancel()
  }

  @action _submit = (e) => {
    e && e.preventDefault()

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
