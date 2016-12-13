import FastClick from  'fastclick'
import { autorun, useStrict } from 'mobx'
import React from  'react'
import ReactDOM from 'react-dom'

import Root from './app/root'

new FastClick(document.body)
useStrict(true)

if (window.env !== 'production') {
  window.autorun = autorun
}

ReactDOM.render(<Root />, document.getElementById('app'))
