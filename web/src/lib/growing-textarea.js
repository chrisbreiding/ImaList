/*
* Credit: https://github.com/andreypopp/react-textarea-autosize
*/

import _ from 'lodash';
import React from 'react';
import { findDOMNode } from 'react-dom';

export default React.createClass({
  displayName: 'TextareaAutosize',

  render: function() {
    var props = _.extend({}, this.props, {
      ref: 'textarea',
      onChange: this.onChange,
      style: _.extend({}, this.props.style, {overflow: 'hidden'})
    });

    return React.DOM.textarea(props, this.props.children);
  },

  componentDidMount: function() {
    this.getDiffSize();
    this.recalculateSize();
  },

  componentWillReceiveProps: function(nextProps) {
    this.dirty = !!nextProps.style;
  },

  componentDidUpdate: function() {
    if (this.dirty) {
      this.getDiffSize();
      this.dirty = false;
    }
  },

  onChange: function(e) {
    if (this.props.onChange) {
      this.props.onChange(e);
    }
    this.recalculateSize();
  },

  getDiffSize: function() {
    if (window.getComputedStyle) {
      var styles = window.getComputedStyle(this._getDOMNode());

      // If the textarea is set to border-box, it's not necessary to
      // subtract the padding.
      if (styles.getPropertyValue('box-sizing') === "border-box" ||
          styles.getPropertyValue('-moz-box-sizing') === "border-box" ||
          styles.getPropertyValue('-webkit-box-sizing') === "border-box") {
        this.diff = 0;
      } else {
        this.diff = (
            parseInt(styles.getPropertyValue('padding-bottom') || 0, 10) +
            parseInt(styles.getPropertyValue('padding-top') || 0, 10)
            );
      }
    } else {
      this.diff = 0;
    }
  },

  recalculateSize: function() {
    if (!this.isMounted()) {
      return;
    }

    var node = this._getDOMNode();
    node.style.height = (node.scrollHeight - this.diff) + 'px';
  },

  _getDOMNode () {
    return findDOMNode(this.refs.textarea);
  }
});
