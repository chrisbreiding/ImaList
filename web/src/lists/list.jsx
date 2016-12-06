import cs from 'classnames'
import { action, observable } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'
import { findDOMNode } from 'react-dom'

import ActionSheet from '../modal/action-sheet'

@observer
class List extends Component {
  @observable isFocused = false
  @observable attemptingRemove

  componentDidUpdate (prevProps) {
    if (!prevProps.isEditing && this.props.isEditing) {
      this.refs.name.focus()
    }
  }

  render () {
    const { model } = this.props

    return (
      <li
        className={cs({
          'list': true,
          'shared': model.shared,
          'is-private': model.isPrivate,
          'is-owner': this.props.isOwner,
          'showing-options': this.props.isEditing,
          'is-editing': this.props.isEditing,
          'is-selected': this.props.isSelected,
          'is-focused': this.isFocused,
        })}
        data-id={model.id}
      >
        <i className='sort-handle fa fa-arrows'></i>
        <span className='name' onClick={this._select}>
          {this._name()}
        </span>
        <div className='options'>
          <div className='indicators'>
            <i className='shared-indicator fa fa-share-alt-square'></i>
            <i className='is-private-indicator fa fa-lock'></i>
          </div>
          <button className='toggle-options' onClick={this._toggleEditing}>
            <i className='fa fa-ellipsis-h'></i>
          </button>
          <button className='toggle-shared' onClick={this._toggleShared}>
            <i className='fa fa-share-alt'></i>
          </button>
          <button className='toggle-is-private' onClick={this._toggleIsPrivate}>
            <i className={`fa fa-${model.isPrivate ? 'unlock-alt' : 'lock'}`}></i>
          </button>
          <button className='remove' onClick={this._attemptRemove}>
            <i className='fa fa-times'></i>
          </button>
        </div>
        <ActionSheet
          isShowing={this.attemptingRemove}
          actions={[
            {
              label: 'Remove List',
              handler: this._remove,
            }, {
              label: 'Cancel',
              handler: this._cancelRemove,
              type: 'cancel',
            },
          ]}
        />
      </li>
    )
  }

  _name () {
    if (this.props.isEditing) {
      return (
        <input
          ref='name'
          defaultValue={this.props.model.name}
          onChange={this._updateName}
          onKeyUp={this._keyup}
          onFocus={this._focus}
          onBlur={this._blur}
        />
      )
    } else {
      return this.props.model.name
    }
  }

  _select = () => {
    if (!this.props.isEditing) {
      this.props.onSelect(this.props.model)
    }
  }

  @action _attemptRemove = () => {
    this.attemptingRemove = true
  }

  _remove = () => {
    this.props.onRemove(this.props.model)
  }

  @action _cancelRemove = () => {
    this.attemptingRemove = false
  }

  @action _toggleEditing = () => {
    if (this.props.isEditing) this.isFocused = false
    this.props.onEdit(this.props.isEditing ? { id: null } : this.props.model)
  }

  _toggleShared = () => {
    this.props.onUpdate({
      id: this.props.model.id,
      shared: !this.props.model.shared,
    })
  }

  _toggleIsPrivate = () => {
    this.props.onUpdatePrivacy({
      id: this.props.model.id,
      willBePrivate: !this.props.model.isPrivate,
    })
  }

  _updateName = () => {
    this.props.onUpdate({
      id: this.props.model.id,
      name: findDOMNode(this.refs.name).value,
    })
  }

  _keyup = (e) => {
    if (e.key === 'Enter' || e.key === 'Escape') {
      this._toggleEditing()
    }
  }

  @action _focus = () => {
    this.isFocused = true
  }

  @action _blur = () => {
    this.isFocused = false
  }
}

export default List
