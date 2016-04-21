import FastClick from  'fastclick';
import React from  'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import { store } from './data/store';
import Root from './app/root';

new FastClick(document.body);

ReactDOM.render(
  <Provider store={store}>
    <Root />
  </Provider>,
  document.getElementById('app')
);
