import React, { Component } from 'react'
import Textarea from 'react-textarea-autosize'

import Modal from '../modal/modal'

class BulkAdd extends Component {
  componentDidMount () {
    this.refs.bulkItems.focus()
  }

  render () {
    const lotsOfSpaces = Array(40).join(' ')

    return (
      <div>
        <Textarea
          ref='bulkItems'
          minRows={5}
          placeholder={`• Separate items with new lines${lotsOfSpaces}• Prefix with # to make a label`}
        />
        <footer className='actions'>
          <button className='cancel' onClick={this.props.onCancel}>
            Cancel
          </button>
          <button className='format' onClick={this._format}>
            Format
          </button>
          <button
            className='submit'
            onClick={this._add}
          >
            Add
          </button>
        </footer>
      </div>
    )
  }

  _format = () => {
    const value = this.refs.bulkItems.value

    this.refs.bulkItems.value = value.split('\n').map((line) => {
      // strip non-word characters from beginning of lines
      line = line.replace(/^\s*[^a-zA-Z#]+\s*/, '')
      // clean up #s, which denote labels
      line = line.replace(/^\s*#+\s*/, '# ')
      return line
    }).join('\n')
  }

  _add = () => {
    this.props.onAdd(this.refs.bulkItems.value.split('\n'))
  }
}

const BulkAddModal = (props) => (
  <Modal className='bulk-add light-box' isShowing={props.isShowing}>
    <BulkAdd {...props} />
  </Modal>
)

export default BulkAddModal
