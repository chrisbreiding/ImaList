import cs from 'classnames';
import React from 'react';

import Portal from './portal';

export default (props) => (
  <Portal className={cs('action-sheet', {
      'action-sheet-showing': props.isShowing
  })}>
    <div className='container'>
      <button className='confirm' onClick={props.onConfirm}>
        {props.confirmMessage || 'Confirm'}
      </button>
      <button className='cancel' onClick={props.onCancel}>
        {props.cancelMessage || 'Cancel'}
      </button>
    </div>
  </Portal>
);
