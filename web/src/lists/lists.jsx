import { action, observable } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

import appState from '../app/app-state'

import ListsList from './lists-list'
import Settings from '../app/settings'

@observer
class Lists extends Component {
  render () {
    return (
      <div className='lists'>
        <header className='fixed'>
          <h1>ImaList</h1>
        </header>
        <ListsList listsStore={this.props.listsStore} />
        <footer>
          <button onClick={this._addList}>
            <span>List</span>
            <i className='fa fa-plus'></i>
          </button>
          <div className='spacer'></div>
          <button className='settings' onClick={this._showSettings}>
            <span>Settings</span>
            <i className='fa fa-cog'></i>
          </button>
          <button className='logout' onClick={this.props.onLogout}>
            <span>Logout</span>
            <i className='fa fa-sign-out'></i>
          </button>
        </footer>
        <Settings />
      </div>
    )
  }

  @action _addList = () => {
    this.props.listsStore.addList()
  }

  @action _showSettings = () => {
    appState.viewingSettings = true
  }
}

export default Lists
