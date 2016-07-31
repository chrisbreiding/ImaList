import _ from 'lodash'
import { action } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

import authState from '../login/auth-state'

import SortableList from '../lib/sortable-list'
import List from './list'

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
            isOwner={list.owner === authState.userEmail}
            isEditing={list.id === this.props.listsStore.editingListId}
            isSelected={list.id === this.props.listsStore.selectedId}
            onSelect={this._goToList}
            onUpdate={this._updateList}
            onRemove={this._attemptRemoveList}
          />
        ))}
      </SortableList>
    )
  }

  @action _goToList = (list) => {
    this.props.listsStore.selectList(list)
  }

  @action _updateList = (list) => {
    this.props.listsStore.updateList(list)
  }

  @action _attemptRemoveList = (list) => {
    this.props.listsStore.attemptRemoveList(list)
  }
}

export default ListsList
