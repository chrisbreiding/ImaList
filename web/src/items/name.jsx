import React, { Component } from 'react';
import { findDOMNode } from 'react-dom';
import Textarea from 'react-textarea-autosize';

const ENTER_DELAY = 200;

export default class Name extends Component {
  render () {
    return <Textarea
      ref='name'
      className='name'
      value={this.props.name}
      onFocus={() => this.props.onEditingStatusChange(true)}
      onBlur={() => this.props.onEditingStatusChange(false)}
      onChange={this._updateName.bind(this)}
      onKeyDown={this._onKeyDown.bind(this)}
      onKeyUp={this._onKeyUp.bind(this)}
    />;
  }

  focus () {
    this._getDOMNode().focus();
  }

  hasValue () {
    return !!this._value().trim();
  }

  addNewLine () {
    this.props.onUpdate(this._value() + '\n');
  }

  _value () {
    return this._getDOMNode().value || '';
  }

  _updateName () {
    this.props.onUpdate(this._value());
  }

  _onKeyDown (e) {
    if (e.key === 'Enter') {
      e.preventDefault();
    }
  }

  _onKeyUp (e) {
    const isEnter = e.key === 'Enter';

    if ((isEnter && e.shiftKey) || (isEnter && this._shouldAddNewLine())) {
      this.addNewLine();
      return;
    }

    if (isEnter) {
      clearTimeout(this._nextTimeout);
      this._nextTimeout = setTimeout(() => {
        this._nextTimeout = null;
        if (this.hasValue()) this.props.onNext();
      }, ENTER_DELAY);
    }

    if (e.key === 'Escape') {
      this._getDOMNode().blur();
    }
  }

  _shouldAddNewLine () {
    const shouldAdd = !!this._nextTimeout;
    clearTimeout(this._nextTimeout);
    this._nextTimeout = null;
    return shouldAdd;
  }

  _getDOMNode () {
    return findDOMNode(this.refs.name);
  }
}
