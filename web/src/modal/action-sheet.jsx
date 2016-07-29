import _ from 'lodash'
import React from 'react'

import Modal from './modal'

const ActionSheet = (props) => (
  <Modal {...props} className='action-sheet'>
    {_.map(props.actions, ({ label, handler, type = 'confirm' }) => (
      <button key={label} className={type} onClick={handler}>{label}</button>
    ))}
  </Modal>
)

export default ActionSheet
