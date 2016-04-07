import cs from 'classnames';
import React, { createClass } from 'react';
import { findDOMNode } from 'react-dom';

export default createClass({
  displayName: 'List',

  getInitialState () {
    return {
      editing: false,
      showingOptions: false
    };
  },

  render () {
    return (
      <li
        className={cs({
          'list': true,
          'showing-options': this.state.showingOptions,
          'shared': this.props.model.shared,
          'is-owner': this.props.isOwner,
          'is-selected': this.props.isSelected,
        })}
        data-id={this.props.id}
      >
        <i className='sort-handle fa fa-arrows'></i>
        <span>{this._name()}</span>
        <div className='options'>
          <i className='shared-indicator fa fa-share-alt-square'></i>
          <button className='toggle-options' onClick={this._toggleOptions}>
            <i className='fa fa-ellipsis-h'></i>
          </button>
          <button className='toggle-shared' onClick={this._toggledShared}>
            <i className='fa fa-share-alt'></i>
          </button>
          <button className='remove' onClick={this._remove}>
            <i className='fa fa-times'></i>
          </button>
        </div>
      </li>
    );
  },

  _name () {
    if (this.state.editing) {
      return <input
        ref='name'
        className='name'
        defaultValue={this.props.model.name}
        onChange={this._updateName}
        onKeyUp={this._keyup}
      />;
    } else {
      return <span className='name' onClick={this.props.onSelect}>
        {this.props.model.name}
      </span>;
    }
  },

  _toggleOptions () {
    const show = !this.state.showingOptions;
    this.setState({
      showingOptions: show
    }, () => this._toggleEditing(show));
  },

  _toggleEditing (editing) {
    return this.setState({ editing });
  },

  _toggledShared () {
    this.props.model.shared = !this.props.model.shared;
    this._update();
  },

  _remove () {
    this.props.onRemove();
  },

  _updateName () {
    this.props.model.name = findDOMNode(this.refs.name).value;
    this._update();
  },

  _update () {
    this.props.onUpdate(this.props.model);
  },

  _keyup (e) {
    if (e.key === 'Enter') {
      this._toggleOptions();
    }
  },

  edit () {
    this._toggleOptions();
  },
});
