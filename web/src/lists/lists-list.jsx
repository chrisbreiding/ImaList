import _ from 'lodash'
import { action } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

import authState from '../auth/auth-state'

import List from './list'
import SortableList from '../lib/sortable-list'

@observer
class ListsList extends Component {
  render () {
    if (this.props.listsStore.isLoading) {
      return <p className='no-items'><i className='fa fa-hourglass-end fa-spin'></i> Loading...</p>
    } else if (!this.props.listsStore.lists.length) {
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
        {_.map(this.props.listsStore.lists, (list) => (
          <List
            key={list.id}
            model={list}
            isOwner={list.owner === authState.user.email}
            isEditing={list.id === this.props.listsStore.editingListId}
            isSelected={list.id === this.props.listsStore.selectedListId}
            onEdit={this._editList}
            onSelect={this._goToList}
            onUpdate={this._updateList}
            onUpdatePrivacy={this._updateListPrivacy}
            onRemove={this._attemptRemoveList}
          />
        ))}
      </SortableList>
    )
  }

  @action _editList = (list) => {
    this.props.listsStore.editList(list)
  }

  @action _goToList = (list) => {
    this.props.listsStore.selectList(list)
  }

  @action _updateList = (list) => {
    this.props.listsStore.updateList(list)
  }

  @action _updateListPrivacy = ({ id, willBePrivate }) => {
    authState.passcodeNeeded = true
    authState.onPasscodeSubmit = action('finished:password:action', () => {
      this._updateList({ id, isPrivate: willBePrivate })
      authState.resetPasscodeCallbacks()
    })
  }

  @action _attemptRemoveList = (list) => {
    this.props.listsStore.attemptRemoveList(list)
  }
}

export default ListsList
