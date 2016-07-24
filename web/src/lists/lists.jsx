import cs from 'classnames'
import _ from 'lodash'
import { action, observable } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

import authState from '../login/auth-state'

import ActionSheet from '../modal/action-sheet'
import SortableList from '../lib/sortable-list'
import List from './list'

@observer
class Lists extends Component {
  @observable editing = false

  render () {
    return (
      <div className={cs('lists', { editing: this.editing })}>
        <header className='fixed'>
          <h1>ImaList</h1>
          <button className='edit' onClick={this._toggleEditing}>
            {this.editing ? <span>Done</span> : <i className='fa fa-sort'></i>}
          </button>
        </header>
        {this._lists(this.props.lists)}
        <footer>
          <button onClick={() => this._addList(this.props.lists)}>
            <span>List</span>
            <i className='fa fa-plus'></i>
          </button>
          <div className='spacer'></div>
          <button className='logout' onClick={this.props.onLogout}>
            <span>Logout</span>
            <i className='fa fa-sign-out'></i>
          </button>
        </footer>
        {this._removeConfirmation()}
      </div>
    )
  }

  // TODO: optimize by moving to own component
  _lists (lists) {
    if (this.props.listsStore.isLoading) {
      return <p className='no-items'><i className='fa fa-hourglass-end fa-spin'></i> Loading...</p>
    } else if (!lists.length) {
      return <p className='no-items'>No Lists</p>
    }

    return (
      <SortableList
        el='ul'
        handleClass='sort-handle'
        onSortingUpdate={(ids) => {
          _.each(ids, (id, order) => this._updateList({ id, order }))
        }}
      >
        {_.map(lists, (list) => (
          <List
            key={list.id}
            ref={list.id}
            model={list}
            isOwner={list.owner === authState.userEmail}
            isEditing={list.id === this.props.listsStore.editingListId}
            isSelected={list.id === this.props.listsStore.selectedId}
            onEdit={(shouldEdit) => this._editList(list, shouldEdit)}
            onSelect={() => this._goToList(list)}
            onUpdate={(list) => this._updateList(list)}
            onRemove={() => this._attemptRemoveList(list)}
          />
        ))}
      </SortableList>
    )
  }

  _removeConfirmation () {
    const listId = this.props.listsStore.attemptingRemoveListId

    return (
      <ActionSheet
        isShowing={!!listId}
        confirmMessage='Remove List'
        onConfirm={action('list:removal:confirmed', () => this.props.listsStore.removeList(listId))}
        onCancel={action('list:removal:canceled', () => this.props.listsStore.attemptRemoveList(false))}
      />
    )
  }

  @action _editList (list, shouldEdit) {
    this.props.listsStore.editList(shouldEdit ? list.id : null)
  }

  @action _goToList (list) {
    this.props.listsStore.selectList(list.id)
  }

  @action _addList (lists) {
    this.props.listsStore.addList(lists, authState.userEmail)
  }

  @action _updateList (list) {
    this.props.listsStore.updateList(list)
  }

  @action _attemptRemoveList (list) {
    this.props.listsStore.attemptRemoveList(list.id)
  }

  @action _toggleEditing = () => {
    this.editing = !this.editing
  }
}

export default Lists
