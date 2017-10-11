import cs from 'classnames'
import { action, observable } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'
import { findDOMNode } from 'react-dom'
import { DragSource, DropTarget } from 'react-dnd'

import Name from './name'
import { sortableSource, sortableTarget } from '../lib/sortable-list'

@DropTarget('sortable-item', sortableTarget, (connect) => ({
  connectDropTarget: connect.dropTarget(),
}))
@DragSource('sortable-item', sortableSource, (connect, monitor) => ({
  connectDragPreview: connect.dragPreview(),
  connectDragSource: connect.dragSource(),
  isDragging: monitor.isDragging(),
}))
@observer
export default class Item extends Component {
  @observable isEditing = false
  @observable showingOptions = false

  @action componentDidUpdate () {
    if (this.props.isEditing && !this.isEditing) {
      this.isEditing = true
      this.refs.name.focus()
    }

    if (!this.props.isEditing && this.isEditing) {
      this.isEditing = false
    }
  }

  render () {
    const type = this.props.model.type || 'todo'

    const {
      connectDragPreview,
      // isDragging,
      connectDragSource,
      connectDropTarget,
    } = this.props

    return connectDragPreview(connectDropTarget(
      <li
        className={cs('item', `type-${type}`, {
          'is-checked': this.props.model.isChecked,
          'is-collapsed': this.props.isCollapsed,
          'showing-options': this.showingOptions,
        })}
      >
        <Name
          ref='name'
          name={this.props.model.name}
          onEditingStatusChange={this._onEditingStatusChange}
          onUpdate={this._updateName}
          onNext={this.props.onNext}
        ></Name>
        <button
          ref='toggleChecked'
          className='toggle-checked'
          onClick={this._toggleChecked}
        >
          <i className='fa fa-check'></i>
        </button>
        <button
          className='toggle-collapsed'
          onClick={this._toggleCollapsed}
        >
          <i className='fa fa-caret-down'></i>
        </button>
        {connectDragSource(<i className='sort-handle fa fa-arrows'></i>)}
        <div className='options'>
          <button className='toggle-options' onClick={this._toggleOptions}>
            <i className='fa fa-ellipsis-h'></i>
          </button>
          <button className='remove' onClick={this._remove}>
            <i className='fa fa-times'></i>
          </button>
        </div>
      </li>
    ))
  }

  _toggleChecked = () => {
    findDOMNode(this.refs.toggleChecked).blur()
    this.props.onUpdate({
      id: this.props.model.id,
      isChecked: !this.props.model.isChecked,
    })
  }

  _toggleCollapsed = () => {
    this.props.onToggleCollapsed(this.props.model)
  }

  @action _onEditingStatusChange = (isEditing) => {
    this.props.onEdit(this.props.model, isEditing)
    this.showingOptions = false
  }

  _updateName = (name) => {
    this.props.onUpdate({
      id: this.props.model.id,
      name,
    })
  }

  @action _toggleOptions = () => {
    this.showingOptions = !this.showingOptions
  }

  _remove = () => {
    this.props.onRemove(this.props.model)
  }
}
