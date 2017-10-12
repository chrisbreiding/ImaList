import _ from 'lodash'
import { action } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'
import { SortableContainer, arrayMove } from 'react-sortable-hoc'

import authState from '../auth/auth-state'

import List from './list'

@observer
class ListsList extends Component {
  render () {
    return (
      <ul>
        {_.map(this.props.listsStore.lists, (list, index) => (
            <List
            key={list.id}
            index={index}
            model={list}
            isOwner={list.owner === authState.user.email}
            isEditing={list.id === this.props.listsStore.editingListId}
            isSelected={list.id === this.props.listsStore.selectedListId}
            onEdit={this._editList}
            onSelect={this._goToList}
            onUpdate={this._updateList}
            onUpdatePrivacy={this._updateListPrivacy}
            onRemove={this._removeList}
          />
        ))}
      </ul>
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

  @action _removeList = (list) => {
    this.props.listsStore.removeList(list)
  }
}

const SortableListsList = SortableContainer(ListsList)

const ListsListContainer = (props) => {
  const onSortEnd = ({ oldIndex, newIndex }) => {
    const ids = arrayMove(_.map(props.listsStore.lists, 'id'), oldIndex, newIndex)
    _.each(ids, (id, order) => props.listsStore.updateList({ id, order }))
  }

  if (props.listsStore.isLoading) {
    return <p className='no-items'><i className='fa fa-hourglass-end fa-spin'></i> Loading...</p>
  } else if (!props.listsStore.lists.length) {
    return <p className='no-items'>No Lists</p>
  }

  return (
    <SortableListsList
      {...props}
      helperClass='sorting-helper'
      onSortEnd={onSortEnd}
      useDragHandle={true}
    />
  )
}

export default ListsListContainer
