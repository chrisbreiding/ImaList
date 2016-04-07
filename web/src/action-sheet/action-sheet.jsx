import cs from 'classnames';
import React from 'react';

let previousConfirm, previousCancel;

export default function ActionSheet (props) {
  if (props.confirmMessage) {
    previousConfirm = props.confirmMessage;
  }
  if (props.cancelMessage) {
    previousCancel = props.cancelMessage;
  }

  return (
    <div
      className={cs({
        'action-sheet': true,
        'action-sheet-showing': !!props.onConfirm,
      })}
    >
      <div className='container'>
        <button className='confirm' onClick={props.onConfirm}>
          {props.confirmMessage || previousConfirm || 'Confirm'}
        </button>
        <button className='cancel' onClick={props.onCancel}>
          {props.cancelMessage || previousCancel || 'Cancel'}
        </button>
      </div>
    </div>
  );
};
