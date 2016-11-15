import { observer } from 'mobx-react'
import React, { Component } from 'react'

@observer
class PasscodeInput extends Component {
  render () {
    return (
      <input
        ref='passcode'
        className='passcode-input'
        type='tel'
        value={this.props.value}
        onChange={this._updatePasscode}
      />
    )
  }

  _updatePasscode = (e) => {
    const value = e.target.value.toString()
    if (value.length <= 4) {
      this.props.onChange(value)
    }
  }

  focus () {
    this.refs.passcode.focus()
  }
}

export default PasscodeInput
