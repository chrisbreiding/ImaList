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
    switch (authState.passcodeAction) {
      case C.CONFIRM_PASSCODE:
        return 'Enter your passcode'
      case C.SET_PASSCODE:
        return 'Set a passcode'
      default:
        return ''
    }
  }

  _button () {
    switch (authState.passcodeAction) {
      case C.SET_PASSCODE:
        return 'Set passcode'
      default:
        return 'Submit'
    }
  }

  @action _updatePasscode = (passcode) => {
    this.passcode = passcode
  }

  @action _cancel = (e) => {
    e.preventDefault()
    authState.passcodeAction = null
    authState.onPasscodeCancel()
  }

  @action _submit = (e) => {
    e.preventDefault()

    if (!this.isValid) return

    switch (authState.passcodeAction) {
      case C.CONFIRM_PASSCODE: {
        if (authState.user.passcode !== this.passcode) {
          this.error = 'Passcode incorrect'
          this.refs.oldPasscode.focus()
          return
        }
        break
      }
      case C.SET_PASSCODE: {
        auth.updatePasscode(this.passcode)
        break
      }
      default: {} // eslint-disable-line no-empty
    }

    authState.passcodeAction = null
    authState.onPasscodeSubmit()
  }
}

export default Passcode
