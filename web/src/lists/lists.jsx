import cs from 'classnames';
import _ from 'lodash';
import React, { createClass } from 'react';

import SortableList from '../lib/sortable-list';
import List from './list';
import ListModel from './list-model';

export default createClass({
  displayName: 'Lists',

  getInitialState: function() {
    return { editing: false };
  },

  render: function() {
    return (
      <div
        className={cs({
          lists: true,
          editing: this.state.editing,
        })}
      >
        <header>
          <h1>ImaList</h1>
          <button className='edit' onClick={this._toggleEditing}>
            {this.state.editing ? <span>Done</span> : <i className='fa fa-sort'></i>}
          </button>
        </header>
        <SortableList
          el='ul'
          handleClass='sort-handle'
          onSortingUpdate={(ids) => {
            _.each(ids, (id, index) => {
              this.props.onUpdate(id, { order: index });
            });
          }}
        >
          {_.map(this.props.lists, list => (
            <List
              key={list.id}
              ref={list.id}
              id={list.id}
              model={new ListModel(list)}
              isOwner={list.owner === this.props.userEmail}
              isSelected={list.id === this.props.selectedListId}
              onSelect={_.partial(this.props.onListSelect, list.id)}
              onUpdate={_.partial(this.props.onUpdate, list.id)}
              onRemove={_.partial(this.props.onRemove, list.id)}
            />
          ))}
        </SortableList>
        <footer>
          <button onClick={this.props.onAdd}>
            <i className='fa fa-plus'></i>
          </button>
          <button className='logout' onClick={this.props.onLogout}>
            <i className='fa fa-sign-out'></i>
          </button>
        </footer>
      </div>
    );
  },

  edit: function(id) {
    this.refs[id].edit();
  },

  _toggleEditing: function() {
    this._setEditing(!this.state.editing);
  },

  _setEditing: function(editing) {
    this.setState({ editing });
  },
});
