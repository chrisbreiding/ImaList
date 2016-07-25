import cs from 'classnames'
import { observer } from 'mobx-react'
import React, { Component } from 'react'
import { findDOMNode } from 'react-dom'

@observer
export default class List extends Component {
  constructor (props) {
    super(props)

    this.state = {
      editing: false,
      showingOptions: false,
    }
  }

  componentDidUpdate () {
    if (this.props.isEditing && !this.state.editing) {
      this.setState({ editing: true, showingOptions: true }, () => {
        this.refs.name.focus()
      })
    }

    if (!this.props.isEditing && this.state.editing) {
      this.setState({ editing: false })
    }
  }

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
        data-id={this.props.model.id}
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
          <button className='remove' onClick={this._removeList}>
            <i className='fa fa-times'></i>
          </button>
        </div>
      </li>
    )
  }

  _name () {
    if (this.state.showingOptions) {
      return (
        <input
          ref='name'
          className='name'
          defaultValue={this.props.model.name}
          onChange={this._updateName}
          onKeyUp={this._keyup}
        />
      )
    } else {
      return (
        <span className='name' onClick={this._selectList}>
          {this.props.model.name}
        </span>
      )
    }
  }

  _selectList = () => {
    this.props.onSelect(this.props.model)
  }

  _removeList = () => {
    this.props.onRemove(this.props.model)
  }

  _toggleOptions = () => {
    this.setState({ showingOptions: !this.state.showingOptions })
  }

  _toggledShared = () => {
    this.props.onUpdate({
      id: this.props.model.id,
      shared: !this.props.model.shared,
    })
  }

  _updateName = () => {
    this.props.onUpdate({
      id: this.props.model.id,
      name: findDOMNode(this.refs.name).value,
    })
  }

  _keyup = (e) => {
    if (e.key === 'Enter') {
      this._toggleOptions()
    }
  }
}

export default List
