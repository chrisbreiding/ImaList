import cs from 'classnames';
import _ from 'lodash';
import { connect } from 'react-redux';
import React, { Component } from 'react';

import { editList, selectList, addList, updateList, attemptRemoveList, removeList } from './lists-actions';

import ActionSheet from '../modal/action-sheet';
import SortableList from '../lib/sortable-list';
import List from './list';

class Lists extends Component {
  constructor (props) {
    super(props);
    this.state = { editing: false };
  }

  render () {
    const { lists } = this.props;

    return (
      <div
        className={cs('lists', {
          editing: this.state.editing,
        })}
      >
        <header>
          <h1>ImaList</h1>
          <button className='edit' onClick={this._toggleEditing.bind(this)}>
            {this.state.editing ? <span>Done</span> : <i className='fa fa-sort'></i>}
          </button>
        </header>
        {this._lists(lists)}
        <footer>
          <button onClick={this._addList.bind(this)}>
            <span>List</span>
            <i className='fa fa-plus'></i>
          </button>
          <div className='spacer'></div>
          <button className='logout' onClick={this.props.onLogout}>
            <span>Logout</span>
            <i className='fa fa-sign-out'></i>
          </button>
        </footer>
        {this._confirmRemoval()}
      </div>
    );
  }

  _lists (lists) {
    if (this.props.isLoading) {
      return <p className='no-items'><i className='fa fa-hourglass-end fa-spin'></i> Loading...</p>;
    } else if (!lists.length) {
      return <p className='no-items'>No Lists</p>;
    }

    return (
      <SortableList
        el='ul'
        handleClass='sort-handle'
        onSortingUpdate={(ids) => {
          _.each(ids, (id, order) => this._updateList({ id, order }));
        }}
      >
        {_.map(lists, (list) => (
          <List
            key={list.id}
            ref={list.id}
            model={list}
            isOwner={list.owner === this.props.auth.email}
            isEditing={list.id === this.props.app.editListId}
            isSelected={list.id === this.props.selectedListId}
            onEdit={(shouldEdit) => this._editList(list, shouldEdit)}
            onSelect={() => this._goToList(list)}
            onUpdate={(list) => this._updateList(list)}
            onRemove={() => this._removeList(list)}
          />
        ))}
      </SortableList>
    );
  }

  _editList (list, shouldEdit) {
    this.props.dispatch(editList(shouldEdit ? list.id : null));
  }

  _goToList (list) {
    this.props.dispatch(selectList(list.id));
  }

  _addList () {
    this.props.dispatch(addList(this.props.lists, this.props.auth.email));
  }

  _updateList (list) {
    this.props.dispatch(updateList(list));
  }

  _removeList (list) {
    this.props.dispatch(attemptRemoveList(list.id));
  }

  _toggleEditing () {
    this._setEditing(!this.state.editing);
  }

  _setEditing (editing) {
    this.setState({ editing });
  }

  _confirmRemoval () {
    const listId = this.props.app.attemptingRemoveList;

    return (
      <ActionSheet
        isShowing={!!listId}
        confirmMessage='Remove List'
        onConfirm={() => this.props.dispatch(removeList(listId))}
        onCancel={() => this.props.dispatch(attemptRemoveList(false))}
      />
    );
  }
}

export default connect(({ auth, app }) => ({ auth, app }))(Lists);
