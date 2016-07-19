import React, { Component } from 'react';
import Textarea from 'react-textarea-autosize';

import Modal from '../modal/modal';

export default class BulkAdd extends Component {
  componentDidUpdate () {
    if (this.props.isShowing) {
      this.refs.bulkItems.focus();
    } else {
      this.refs.bulkItems.value = '';
    }
  }

  render () {
    return (
      <Modal className='bulk-add modal-form' isShowing={this.props.isShowing}>
        <Textarea
          ref='bulkItems'
          minRows={5}
          placeholder='Separate items with new lines...'
        />
        <footer>
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
      </Modal>
    );
  }
}
