import cs from 'classnames';
import _ from 'lodash';
import React, { createClass } from 'react';

import { curated } from '../lib/collection';
import Item from './item';
import ItemModel from './item-model';
import SortableList from '../lib/sortable-list';

export default createClass({
  displayName: 'Items',

  getInitialState () {
    return { editing: false };
  },

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
          <h1>{this.props.listName}</h1>
          <button className='back' onClick={this._onBack}>
            <i className='fa fa-chevron-left'></i>
          </button>
          <button className='edit' onClick={this._toggleEditing}>
            {this.state.editing ? <span>Done</span> : <i className='fa fa-sort'></i>}
          </button>
        </header>
        {this._itemsList(items)}
        <footer>
          <button onClick={this.props.onAdd}>
            <i className='fa fa-plus'></i>
          </button>
          {this._clearCompleted(items)}
        </footer>
      </div>
    );
  },

  _itemsList (items) {
    if (!items.length) {
      return <p className='no-items'>No Items</p>;
    }

    return (
      <SortableList
        ref='list'
        el='ul'
        handleClass='sort-handle'
        onSortingUpdate={(ids) => {
          _.each(ids, (id, index) => this.props.onUpdate(id, { order: index }));
        }}
      >
      {_.map(items, (item, index) => (
        <Item
          ref={item.id}
          key={item.id}
          id={item.id}
          model={new ItemModel(item)}
          onUpdate={_.partial(this.props.onUpdate, item.id)}
          onRemove={_.partial(this.props.onRemove, item.id)}
          onNext={index === items.length - 1 ? this.props.onAdd : _.partial(this.edit, items[index + 1].id)}
        ></Item>
      ))}
      </SortableList>
    );
  },

  _clearCompleted (items) {
    if (!_.some(items, { isChecked: true })) return null;

    return (
      <button onClick={this.props.onClearCompleted}>
        <i className='fa fa-ban'></i>
      </button>
    );
  },

  edit (id) {
    return this.refs[id].edit();
  },

  _onBack () {
    this._setEditing(false);
    return this.props.onShowLists();
  },

  _toggleEditing () {
    return this._setEditing(!this.state.editing);
  },

  _setEditing (editing) {
    return this.setState({
      editing: editing
    });
  }
});
