import React, { Component } from 'react'
import Textarea from 'react-textarea-autosize'

import Modal from '../modal/modal'

class BulkAdd extends Component {
  componentDidMount () {
    this.refs.bulkItems.focus()
  }

  render () {
    return (
      <div>
        <Textarea
          ref='bulkItems'
          minRows={5}
          placeholder='Separate items with new lines...'
        />
        <footer className='actions'>
          <button className='cancel' onClick={this.props.onCancel}>
            Cancel
          </button>
          <button
            className='add'
            onClick={() => this.props.onAdd(this.refs.bulkItems.value.split('\n'))}
          >
            Add
          </button>
        </footer>
      </div>
    )
  }
}

const BulkAddModal = (props) => (
  <Modal className='bulk-add light-box' isShowing={props.isShowing}>
    <BulkAdd {...props} />
  </Modal>
)

export default BulkAddModal
