import _ from 'lodash';
import React, { Component } from 'react';
import { findDOMNode } from 'react-dom';

import Textarea from '../lib/growing-textarea';

export default class Name extends Component {
  render () {
    return <Textarea
      ref='name'
      className='name'
      value={this.props.name}
      onFocus={_.partial(this.props.onEditingStatusChange, true)}
      onBlur={_.partial(this.props.onEditingStatusChange, false)}
      onChange={this._updateName.bind(this)}
      onKeyDown={this._onKeyDown.bind(this)}
      onKeyUp={this._onKeyUp.bind(this)}
    />;
  }

  focus () {
    this._getDOMNode().focus();
  }

  hasValue () {
    return !!this._getDOMNode().value;
  }

  _updateName () {
    this.props.onUpdate(this._getDOMNode().value);
  }

  _onKeyDown (e) {
    if (e.key === 'Enter' && e.shiftKey) {
      e.preventDefault();
    }
  }

  _onKeyUp (e) {
    if (e.key === 'Enter' && e.shiftKey && this.hasValue()) {
      this.props.onNext();
      return;
    }

    if (e.key === 'Escape') {
      this._getDOMNode().blur();
    }
  }

  _getDOMNode () {
    return findDOMNode(this.refs.name);
  }
}
