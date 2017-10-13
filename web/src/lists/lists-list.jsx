import _ from 'lodash'
import cs from 'classnames'
import { action, observable } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'
import { SortableContainer, arrayMove } from 'react-sortable-hoc'

import authState from '../auth/auth-state'

import List from './list'

@observer
class ListsList extends Component {
  render () {
    return (
      <ul className={cs({ 'is-dragging': this.props.isDragging })}>
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

@observer
class ListsListContainer extends Component {
  @observable isDragging = false

  render () {
    if (this.props.listsStore.isLoading) {
      return <p className='no-items'><i className='fa fa-hourglass-end fa-spin'></i> Loading...</p>
    } else if (!this.props.listsStore.lists.length) {
      return <p className='no-items'>No Lists</p>
    }

    return (
      <SortableListsList
        {...this.props}
        helperClass='sorting-helper'
        isDragging={this.isDragging}
        onSortStart={this._onSortStart}
        onSortEnd={this._onSortEnd}
        useDragHandle={true}
      />
    )
  }

  @action _onSortStart = () => {
    this.isDragging = true
  }

  @action _onSortEnd = ({ oldIndex, newIndex }) => {
    this.isDragging = false
    if (oldIndex === newIndex) return

    const ids = arrayMove(_.map(this.props.listsStore.lists, 'id'), oldIndex, newIndex)
    _.each(ids, (id, order) => this.props.listsStore.updateList({ id, order }))
  }
}

export default ListsListContainer
