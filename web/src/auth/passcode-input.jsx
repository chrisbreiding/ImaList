import _ from 'lodash'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

const validKeys = /(?:\d|Backspace)/

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
            value={this.props.value.charAt(index) || ''}
            onClick={this.focus}
            onKeyUp={this._updatePasscode(index)}
          />
        ))}
      </div>
    )
  }

  componentDidUpdate () {
    this.focus()
  }

  _updatePasscode = (index) => (e) => {
    if (!validKeys.test(e.key)) return

    const currentValue = this.props.value

    const newValue = e.key === 'Backspace' ?
      currentValue.substr(0, currentValue.length - 1) :
      replaceCharAt(currentValue, index, e.key)

    this.props.onChange(newValue)
  }

  focus = () => {
    const valueLength = this.props.value.length
    const focusIndex = valueLength > 3 ? 3 : valueLength
    this.refs[`passcode${focusIndex}`].focus()
  }
}

export default PasscodeInput
