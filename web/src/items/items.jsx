import cs from 'classnames';
import _ from 'lodash';
import React, { Component } from 'react';
import { connect } from 'react-redux';

import { addItem, editItem, updateItem, removeItem, attemptClearCompleted, clearCompleted } from './items-actions';

import ActionSheet from '../action-sheet/action-sheet';
import Item from './item';
import SortableList from '../lib/sortable-list';

function curated (items) {
  return _(items)
    .map((item, id) => _.extend(item, { id }))
    .sortBy('order')
    .value();
};

class Items extends Component {
  constructor (props) {
    super(props);
    this.state = { editing: false };
  }

  render () {
    const items = curated(this.props.items);

    return (
      <div
        className={cs({
          'items': true,
          'editing': this.state.editing
        })}
      >
        <header>
          <h1>{this.props.list.name}</h1>
          <button className='back' onClick={this._onBack.bind(this)}>
            <i className='fa fa-chevron-left'></i>
          </button>
          <button className='edit' onClick={this._toggleEditing.bind(this)}>
            {this.state.editing ? <span>Done</span> : <i className='fa fa-sort'></i>}
          </button>
        </header>
        {this._items(items)}
        <footer>
          <button onClick={() => this._addItem()}>
            <span>Item</span>
            <i className='fa fa-plus'></i>
          </button>
          <button onClick={() => this._addItem('label')}>
            <span>Label</span>
            <i className='fa fa-plus-square'></i>
          </button>
          {this._clearCompletedButton(items)}
        </footer>
        {this._confirmClearCompleted()}
      </div>
    );
  }

  _items (items) {
    if (this.props.isLoading) {
      return <p className='no-items'><i className="fa fa-hourglass-end fa-spin"></i> Loading...</p>;
    } else if (!items.length) {
      return <p className='no-items'>No Items</p>;
    }

    return (
      <SortableList
        ref='list'
        el='ul'
        handleClass='sort-handle'
        onSortingUpdate={(ids) => {
          _.each(ids, (id, order) => this._updateItem({ id, order }));
        }}
      >
      {_.map(items, (item, index) => (
        <Item
          ref={item.id}
          key={item.id}
          model={item}
          isEditing={item.id === this.props.app.editItemId}
          onEdit={(shouldEdit) => this._editItem(item, shouldEdit)}
          onUpdate={(item) => this._updateItem(item)}
          onRemove={() => this._removeItem(item)}
          onNext={() => this._next(items, index)}
        ></Item>
      ))}
      </SortableList>
    );
  }

  _clearCompletedButton (items) {
    if (!_.some(items, { isChecked: true })) return null;

    return (
      <button onClick={this._clearCompleted.bind(this)}>
        <i className='fa fa-ban'></i>
      </button>
    );
  }

  _clearCompleted () {
    this.props.dispatch(attemptClearCompleted());
  }

  _next (items, index) {
    if (index === items.length - 1) {
      this._addItem();
    } else {
      this._editItem(items[index + 1], true);
    }
  }

  _editItem (item, shouldEdit) {
    this.props.dispatch(editItem(shouldEdit ? item.id : null));
  }

  _onBack () {
    this._setEditing(false);
    return this.props.onShowLists();
  }

  _toggleEditing () {
    return this._setEditing(!this.state.editing);
  }

  _setEditing (editing) {
    return this.setState({
      editing: editing
    });
  }

  _addItem (type) {
    this.props.dispatch(addItem(this.props.list, { type }));
  }

  _updateItem (item) {
    this.props.dispatch(updateItem(this.props.list, item));
  }

  _removeItem (item) {
    this.props.dispatch(removeItem(this.props.list, item.id));
  }

  _confirmClearCompleted () {
    return (
      <ActionSheet
        isShowing={this.props.app.attemptingClearCompleted}
        confirmMessage='Clear Completed'
        onConfirm={() => this.props.dispatch(clearCompleted(this.props.list))}
        onCancel={() => this.props.dispatch(attemptClearCompleted(false))}
      />
    );
  }
}

export default connect(({ app }) => ({ app }))(Items);
