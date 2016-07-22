import FastClick from  'fastclick'
import { useStrict } from 'mobx'
import React from  'react'
import ReactDOM from 'react-dom'

import Root from './app/root'

new FastClick(document.body)
useStrict(true)

ReactDOM.render(<Root />, document.getElementById('app'))
