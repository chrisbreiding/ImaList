import cs from 'classnames'
import { action, observable } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

import ActionSheet from '../modal/action-sheet'
import Modal from '../modal/modal'

@observer
class ListEditor extends Component {
  @observable attemptingRemove = false

  render () {
    const { model } = this.props

    return (
      <div
        className={cs({
          'is-shared': model.shared,
          'is-private': model.isPrivate,
          'is-owner': this.props.isOwner,
        })}
      >
        <fieldset>
          <input
            ref='name'
            value={model.name}
            onChange={this._updateName}
          />
          <div className='list-actions'>
            <button className='toggle-shared' onClick={this.props.onToggleShared}>
              <i className='fa fa-share-alt'></i>
              {model.shared ? 'Unshare' : 'Share'}
            </button>
            <button className='toggle-is-private' onClick={this.props.onToggleIsPrivate}>
              <i className={`fa fa-${model.isPrivate ? 'unlock-alt' : 'lock'}`}></i>
              {model.isPrivate ? 'Unlock' : 'Lock'}
            </button>
            <button className='remove' onClick={this._attemptRemove}>
              <i className='fa fa-times'></i>
              Remove
            </button>
          </div>
        </fieldset>
        <div className='actions'>
          <button onClick={this.props.onClose}>Done</button>
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
      </div>
    )
  }

  componentDidMount () {
    this.refs.name.focus()
  }

  _updateName = () => {
    this.props.onUpdateName(this.refs.name.value)
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
}

const ListEditorModal = (props) => (
  <Modal className='list-editor light-box' isShowing={props.isEditing}>
    <ListEditor {...props} />
  </Modal>
)

export default ListEditorModal
