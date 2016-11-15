import { action, computed, observable } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

import auth from './auth'
import authState from './auth-state'
import C from '../data/constants'
import Modal from '../modal/modal'

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
          <input ref='passcode' type='number' value={this.passcode} onChange={this._updatePasscode} />
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

  @action _updatePasscode = (e) => {
    const value = (e.target.value).toString()
    if (value.length <= 4) {
      this.passcode = value
    }
  }

  @action _cancel = (e) => {
    e.preventDefault()
    authState.passcodeAction = null
    authState.onPasscodeCancel()
  }

  @action _submit = (e) => {
    e.preventDefault()

    const passcode = this.passcodeValue()

    switch (authState.passcodeAction) {
      case C.CONFIRM_PASSCODE: {
        if (authState.user.passcode !== passcode) {
          this.error = 'Passcode incorrect'
          return
        }
        break
      }
      case C.SET_PASSCODE: {
        if (!this.isValid) return
        authState.user.passcode = passcode
        auth.updatePasscode(passcode)
        break
      }
      default: {} // eslint-disable-line no-empty
    }

    authState.passcodeAction = null
    authState.onPasscodeSubmit()
  }

  passcodeValue () {
    return (this.refs.passcode.value).toString()
  }
}

export default Passcode
