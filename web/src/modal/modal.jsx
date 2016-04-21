import cs from 'classnames';
import React from 'react';

import Portal from './portal';

export default (props) => (
  <Portal className={cs('modal', props.className, { 'modal-showing': props.isShowing })}>
    <div className='container'>
      {props.children}
    </div>
  </Portal>
);
