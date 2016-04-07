import _ from 'lodash';
import React, { createClass } from 'react';
import { findDOMNode } from 'react-dom';

import Textarea from '../lib/growing-textarea';

export default createClass({
  displayName: 'ItemName',

  render () {
    return <Textarea
      ref='name'
      className='name'
      value={this.props.name}
      onFocus={_.partial(this.props.onEditingStatusChange, true)}
      onBlur={_.partial(this.props.onEditingStatusChange, false)}
      onChange={this._updateName}
      onKeyDown={this._onKeyDown}
      onKeyUp={this._onKeyUp}
    />;
  },

  edit () {
    const domNode = this._getDOMNode();
    domNode.focus();
    if (!domNode.setSelectionRange) return;

    domNode.setSelectionRange(domNode.value.length, domNode.value.length);
  },

  hasValue () {
    return (this._getDOMNode().value || '').trim() !== '';
  },

  _updateName () {
    this.props.onUpdate(this._getDOMNode().value);
  },

  _onKeyDown (e) {
    if (e.key === 'Enter' && e.shiftKey) {
      e.preventDefault();
    }
  },

  _onKeyUp (e) {
    if (e.key === 'Enter' && e.shiftKey && this.hasValue()) {
      this.props.onNext();
      return;
    }

    if (e.key === 'Escape') {
      this._getDOMNode().blur();
    }
  },

  _getDOMNode () {
    return findDOMNode(this.refs.name);
  },
});
