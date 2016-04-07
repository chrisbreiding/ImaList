import cs from 'classnames';
import React, { createClass } from 'react';
import { findDOMNode } from 'react-dom';

import Name from './name';

export default  createClass({
  displayName: 'Item',

  getInitialState () {
    return {
      showingOptions: false,
      editing: false
    };
  },

  render () {
    return (
      <li
        className={cs({
          'item': true,
          'checked': this.props.model.isChecked,
          'editing': this.state.editing,
          'showing-options': this.state.showingOptions,
        })}
        data-id={this.props.id}
      >
        <button
          ref='toggleChecked'
          className='toggle-checked'
          onClick={this._toggleChecked}
        >
          <i className='fa fa-check'></i>
        </button>
        <i className='sort-handle fa fa-arrows'></i>
        <Name
          ref='name'
          name={this.props.model.name}
          editing={this.state.editing}
          onEditingStatusChange={this._onEditingStatusChange}
          onUpdate={this._updateName}
          onNext={this.props.onNext}
        ></Name>
        <button
          className='next'
          onClick={this._nextIfValue}
        >
         <i className='fa fa-level-down'></i>
        </button>
        <div className='options'>
          <button className='toggle-options' onClick={this._toggleOptions}>
            <i className='fa fa-ellipsis-h'></i>
          </button>
          <button className='remove' onClick={this._remove}>
            <i className='fa fa-times'></i>
          </button>
        </div>
      </li>
    );
  },
  edit () {
    this.setState({ editing: true }, () => this.refs.name.edit());
  },

  _nextIfValue () {
    if (this.refs.name.hasValue()) {
      this.props.onNext();
    }
  },

  _toggleChecked () {
    findDOMNode(this.refs.toggleChecked).blur();
    this.props.model.toggleChecked();
    this.props.onUpdate(this.props.model);
  },

  _onEditingStatusChange (editing) {
    this.setState({
      editing: editing,
      showingOptions: false
    });
  },

  _updateName (name) {
    this.props.model.name = name;
    this.props.onUpdate(this.props.model);
  },

  _toggleOptions () {
    this.setState({ showingOptions: !this.state.showingOptions });
  },

  _remove () {
    this.props.onRemove();
  },
});
