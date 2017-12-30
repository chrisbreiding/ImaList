import cs from 'classnames'
import { action, autorun, observable } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

import authState from '../auth/auth-state'

import ActionSheet from '../modal/action-sheet'
import BulkAdd from './bulk-add'
import ItemsList from './items-list'

@observer
class Items extends Component {
  @observable attemptingClearCompleted = false
  @observable bulkAddingItems = false
  @observable canShow = false

  componentDidMount () {
    this._checkCanShow()

    autorun(() => {
      if (this.canShow) {
        this._dismissKeyboard()
      }
    })
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

  _dismissKeyboard () {
    // after a passcode check, the keyboard doesn't go away for some
    // reason on mobile safari, so this ensures it gets dimissed
    this.refs.back.focus()
    this.refs.back.blur()
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
          'has-checked-items': this.props.list.itemsStore.hasCheckedItems,
        })}
      >
        <header className='fixed'>
          <h1>{this.props.list.name}</h1>
          <button ref='back' className='back' onClick={this._onBack}>
            <i className='fa fa-chevron-left'></i>
          </button>
        </header>
        <ItemsList
          addItem={this._addItem}
          canShow={this.canShow}
          isLoading={this.props.isLoading}
          itemsStore={this.props.list.itemsStore}
        />
        <footer>
          <button onClick={() => this._addItem({}, true)}>
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
    this.props.onShowLists()
  }

  @action _addItem = (props = {}, fixFocus = false) => {
    // fixes focusing on new item on iOS safari by synchronously
    // focusing another element first
    if (fixFocus) {
      let focusFixer = document.querySelector('#focus-fixer')
      if (!focusFixer) {
        focusFixer = document.createElement('input')
        focusFixer.id = 'focus-fixer'
        document.body.appendChild(focusFixer)
      }
      focusFixer.focus()
    }
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
