import _ from 'lodash'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

const keys = {
  8: 'Backspace',
  48: '0',
  49: '1',
  50: '2',
  51: '3',
  52: '4',
  53: '5',
  54: '6',
  55: '7',
  56: '8',
  57: '9',
}

function replaceCharAt (str, index, replacement) {
  return str.substr(0, index) + replacement + str.substr(index + replacement.length)
}

@observer
class PasscodeInput extends Component {
  render () {
    return (
      <div className='passcode-input'>
        {_.map(_.range(4), (index) => (
          <input
            key={index}
            ref={`passcode${index}`}
            type='tel'
            value={this.props.value.charAt(index) ? '*' : ''}
            onFocus={this.focus}
            onKeyUp={this._updatePasscode(index)}
            tabIndex={index === this._focusIndex() ? 0 : -1}
          />
        ))}
      </div>
    )
  }

  componentDidUpdate () {
    this.focus()
  }

  _updatePasscode = (index) => (e) => {
    const key = keys[e.which]
    if (key == null) return

    const currentValue = this.props.value

    const newValue = key === 'Backspace' ?
      currentValue.substr(0, currentValue.length - 1) :
      replaceCharAt(currentValue, index, key)

    this.props.onChange(newValue)
  }

  focus = () => {
    this.refs[`passcode${this._focusIndex()}`].focus()
  }

  _focusIndex () {
    const valueLength = this.props.value.length
    return valueLength > 3 ? 3 : valueLength
  }
}

export default PasscodeInput
