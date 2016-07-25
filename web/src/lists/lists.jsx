import cs from 'classnames'
import { action, observable } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

import ActionSheet from '../modal/action-sheet'
import ListsList from './lists-list'

@observer
class Lists extends Component {
  @observable isSorting = false

  render () {
    return (
      <div className={cs('lists', { 'is-sorting': this.isSorting })}>
        <header className='fixed'>
          <h1>ImaList</h1>
          <button className='edit' onClick={this._toggleSorting}>
            {this.isSorting ? <span>Done</span> : <i className='fa fa-sort'></i>}
          </button>
        </header>
        <ListsList listsStore={this.props.listsStore} />
        <footer>
          <button onClick={this._addList}>
            <span>List</span>
            <i className='fa fa-plus'></i>
          </button>
          <div className='spacer'></div>
          <button className='logout' onClick={this.props.onLogout}>
            <span>Logout</span>
            <i className='fa fa-sign-out'></i>
          </button>
        </footer>
        <ActionSheet
          isShowing={!!this.props.listsStore.attemptingRemoveListId}
          confirmMessage='Remove List'
          onConfirm={this._removeList}
          onCancel={this._cancelRemoveList}
        />
      </div>
    )
  }

  @action _addList = () => {
    this.props.listsStore.addList()
  }

  @action _removeList = () => {
    this.props.listsStore.removeList(this.props.listsStore.attemptingRemoveListId)
  }

  @action _cancelRemoveList = () => {
    this.props.listsStore.attemptRemoveList(false)
  }

  @action _toggleSorting = () => {
    this.isSorting = !this.isSorting
  }
}

export default Lists
