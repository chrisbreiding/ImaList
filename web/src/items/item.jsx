import cs from 'classnames'
import { observer } from 'mobx-react'
import React, { Component } from 'react'
import { findDOMNode } from 'react-dom'

import Name from './name'

@observer
export default class Item extends Component {
  constructor (props) {
    super(props)

    this.state = {
      isEditing: false,
      showingOptions: false,
    }
  }

  componentDidUpdate () {
    if (this.props.isEditing && !this.state.isEditing) {
      this.setState({ isEditing: true }, () => {
        this.refs.name.focus()
      })
    }

    if (!this.props.isEditing && this.state.isEditing) {
      this.setState({ isEditing: false })
    }
  }

  render () {
    const type = this.props.model.type || 'todo'

    return (
      <li
        className={cs('item', `type-${type}`, {
          'is-checked': this.props.model.isChecked,
          'is-collapsed': this.props.isCollapsed,
          'showing-options': this.state.showingOptions,
        })}
        data-id={this.props.model.id}
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
          <i className='fa'></i>
        </button>
        <i className='sort-handle fa fa-arrows'></i>
        <div className='options'>
          <button className='toggle-options' onClick={this._toggleOptions}>
            <i className='fa fa-ellipsis-h'></i>
          </button>
          <button className='remove' onClick={this._remove}>
            <i className='fa fa-times'></i>
          </button>
        </div>
      </li>
    )
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

  _onEditingStatusChange = (isEditing) => {
    this.props.onEdit(this.props.model, isEditing)

    this.setState({
      showingOptions: false,
    })
  }

  _updateName = (name) => {
    this.props.onUpdate({
      id: this.props.model.id,
      name,
    })
  }

  _toggleOptions = () => {
    this.setState({ showingOptions: !this.state.showingOptions })
  }

  _remove = () => {
    this.props.onRemove(this.props.model)
  }
}
