import React from 'react'

import Modal from './modal'

const ActionSheet = (props) => (
  <Modal {...props} className='action-sheet'>
    <button className='confirm' onClick={props.onConfirm}>
      {props.confirmMessage || 'Confirm'}
    </button>
    <button className='cancel' onClick={props.onCancel}>
      {props.cancelMessage || 'Cancel'}
    </button>
  </Modal>
)

export default ActionSheet
