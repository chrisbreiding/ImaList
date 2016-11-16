import cs from 'classnames'
import { action, observable } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

import authState from '../auth/auth-state'
import C from '../data/constants'

import ActionSheet from '../modal/action-sheet'
import BulkAdd from './bulk-add'
import ItemsList from './items-list'

@observer
class Items extends Component {
  @observable attemptingClearCompleted = false
  @observable bulkAddingItems = false
  @observable isSorting = false
  @observable canShow = false

  componentWillMount () {
    this._checkCanShow()
  }

  componentDidUpdate () {
    this._checkCanShow()
  }

  _checkCanShow () {
    if (this.props.list.id !== this.listId) {
      this.listId = this.props.list.id
      this._setCanShow()
    }
  }

  _setCanShow () {
    action('set:can:show', () => {
      this.canShow = !this.props.list.isPrivate
      if (!this.canShow) {
        authState.passcodeNeeded = true
        authState.onPasscodeSubmit = action('passcode:confirmed', () => {
          this.canShow = true
          authState.resetPasscodeCallbacks()
        })
        authState.onPasscodeCancel = action('passcode:cancelled', () => {
          this.props.onShowLists()
          authState.resetPasscodeCallbacks()
        })
      }
    })()
  }

  render () {
    return (
      <div
        className={cs({
          'items': true,
          'is-sorting': this.isSorting,
          'has-checked-items': this.props.list.itemsStore.hasCheckedItems,
        })}
      >
        <header className='fixed'>
          <h1>{this.props.list.name}</h1>
          <button className='back' onClick={this._onBack}>
            <i className='fa fa-chevron-left'></i>
          </button>
          <button className='edit' onClick={this._toggleSorting}>
            {this.isSorting ? <span>Done</span> : <i className='fa fa-sort'></i>}
          </button>
        </header>
        <ItemsList
          addItem={this._addItem}
          canShow={this.canShow}
          isLoading={this.props.isLoading}
          itemsStore={this.props.list.itemsStore}
        />
        <footer>
          <button onClick={() => this._addItem()}>
            <span>Item</span>
            <i className='fa fa-plus'></i>
          </button>
          <button onClick={() => this._addItem({ type: 'label' })}>
            <span>Label</span>
            <i className='fa fa-plus-square'></i>
          </button>
          <button onClick={this._attemptBulkAdd}>
            <span>Bulk</span>
            <i className='fa fa-plus-square-o'></i>
          </button>
          <div className='spacer'></div>
          <button className='clear-completed' onClick={this._attemptClearCompleted}>
            <span>Clear <i className='fa fa-check-square-o'></i></span>
            <i className='fa fa-ban'></i>
          </button>
        </footer>
        <BulkAdd
          isShowing={this.bulkAddingItems}
          onCancel={this._cancelBulkAdd}
          onAdd={this._bulkAddItems}
        />
        <ActionSheet
          isShowing={this.attemptingClearCompleted}
          actions={[
            {
              label: 'Clear Completed',
              handler: this._clearCompleted,
            }, {
              label: 'Cancel',
              handler: this._cancelClearCompleted,
              type: 'cancel',
            },
          ]}
        />
      </div>
    )
  }

  @action _attemptClearCompleted = () => {
    this.attemptingClearCompleted = true
  }

  @action _cancelClearCompleted = () => {
    this.attemptingClearCompleted = false
  }

  @action _clearCompleted = () => {
    this.attemptingClearCompleted = false
    this.props.list.itemsStore.clearCompleted(this.props.list)
  }

  @action _onBack = () => {
    this.isSorting = false
    this.props.onShowLists()
  }

  @action _toggleSorting = () => {
    this.isSorting = !this.isSorting
  }

  @action _addItem = (props = {}) => {
    this.props.list.itemsStore.addItem(props)
  }

  @action _attemptBulkAdd = () => {
    this.bulkAddingItems = true
  }

  @action _cancelBulkAdd = () => {
    this.bulkAddingItems = false
  }

  @action _bulkAddItems = (names) => {
    this.bulkAddingItems = false
    this.props.list.itemsStore.bulkAdd(names)
  }
}

export default Items
