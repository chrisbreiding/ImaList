import cs from 'classnames'
import { action } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'
import { SortableElement, SortableHandle } from 'react-sortable-hoc'

import ListEditor from './list-editor'

const SortHandle = SortableHandle(() => <i className='sort-handle fa fa-ellipsis-v'></i>)

@observer
class List extends Component {
  render () {
    const { model } = this.props

    return (
      <li
        className={cs({
          'list': true,
          'is-shared': model.shared,
          'is-private': model.isPrivate,
          'is-owner': this.props.isOwner,
          'is-selected': this.props.isSelected,
        })}
      >
        <span className='list-container'>
          <SortHandle />
          <span className='name' onClick={this._select}>
            {this.props.model.name}
          </span>
          <div className='indicators'>
            <i className='is-shared-indicator fa fa-share-alt-square' title='Shared'></i>
            <i className='is-private-indicator fa fa-lock' title='Locked'></i>
          </div>
          <button className='edit-list' onClick={this._openEditor}>
            <i className='fa fa-ellipsis-h'></i>
          </button>
          <ListEditor
            model={this.props.model}
            isOwner={this.props.isOwner}
            isEditing={this.props.isEditing}
            onUpdateName={this._updateName}
            onToggleShared={this._toggleShared}
            onToggleIsPrivate={this._toggleIsPrivate}
            onRemove={this._remove}
            onClose={this._closeEditor}
          />
        </span>
      </li>
    )
  }

  _select = () => {
    this.props.onSelect(this.props.model)
  }

  @action _openEditor = () => {
    this.props.onEdit(this.props.model)
  }

  @action _closeEditor = () => {
    this.props.onEdit({ id: null })
  }

  _updateName = (name) => {
    this.props.onUpdate({
      id: this.props.model.id,
      name,
    })
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

  _remove = () => {
    this.props.onRemove(this.props.model)
  }
}

export default SortableElement(List)
