import React, { Component } from 'react';
import { connect } from 'react-redux';

import C from '../data/constants'
import { updateFirebaseSettings } from '../app/app-actions';

import Modal from '../modal/modal'

class Settings extends Component {
  componentDidUpdate () {
    if (this.props.app.showingFirebaseSettings) {
      this.refs.appName.focus();
    }
  }

  render () {
    const { app } = this.props

    return (
      <Modal className='settings modal-form' isShowing={this._shouldShowSettings()}>
        <header>
          <h1>Firebase Settings</h1>
        </header>
        <form onSubmit={this._onSubmit.bind(this)}>
          <fieldset>
            <label>App Name</label>
            <input
              ref='appName'
              placeholder='App Name'
              defaultValue={app.appName}
            />
          </fieldset>
          <fieldset>
            <label>API Key</label>
            <input
              ref='apiKey'
              placeholder='API Key'
              defaultValue={app.apiKey}
            />
          </fieldset>
          <fieldset>
            <button>Save</button>
          </fieldset>
        </form>
      </Modal>
    );
  }

  _shouldShowSettings () {
    const { app } = this.props

    return app.state === C.NEEDS_INITIALIZATION
           || app.state === C.NEEDS_FIREBASE_CONFIG
           || app.showingFirebaseSettings;
  }

  _onSubmit (e) {
    e.preventDefault();
    this.props.dispatch(updateFirebaseSettings(this.refs.appName.value, this.refs.apiKey.value))
  }
}

export default connect(({ app }) => ({ app }))(Settings);
