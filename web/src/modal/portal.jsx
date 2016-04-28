import React, { Component } from 'react';
import { render } from 'react-dom';

let idNum = 0;

export default class Portal extends Component {
  componentDidMount () {
    const id = `portal-${idNum++}`;
    let element = document.getElementById(id);
    if (!element) {
      element = document.createElement('div');
      element.id = id;
      document.body.appendChild(element);
    }
    this.element = element;
    this.componentDidUpdate();
  }

  componentWillUnmount () {
    document.body.removeChild(this.element);
  }

  componentDidUpdate () {
    render((
      <div className={this.props.className || ''}>
        {this.props.children}
      </div>
    ), this.element);
  }

  render () {
    return null;
  }
}
