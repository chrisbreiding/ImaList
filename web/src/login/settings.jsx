import cs from 'classnames';
import React, { Component } from 'react';
import { connect } from 'react-redux';
import { updateAppName } from '../app/app-actions';
import { showSettings } from './auth-actions';

class Settings extends Component {
  componentDidUpdate () {
    if (this.props.auth.showingSettings) {
      this.refs.appName.focus();
    }
  }

  render () {
    return (
      <div className={cs('settings', {
        'showing-settings': this.props.auth.showingSettings,
      })}>
        <button onClick={this._toggleShowing.bind(this)}>
          <i className='fa fa-cog'></i> Firebase Settings
        </button>
        <form onSubmit={this._onSubmit.bind(this)}>
          <fieldset>
            <label>App Name</label>
            <input
              ref='appName'
              placeholder='App Name'
              defaultValue={this.props.app.appName}
            />
          </fieldset>
          <fieldset>
            <label>API Key</label>
            <input
              ref='apiKey'
              placeholder='API Key'
              defaultValue={this.props.app.apiKey}
            />
          </fieldset>
        </form>
      </div>
    );
  }

  _toggleShowing () {
    if (this.props.auth.showingSettings) {
      this._updateAppName();
    } else {
      this.props.dispatch(showSettings(true));
    }
  }

  _onSubmit (e) {
    e.preventDefault();
    this._updateAppName();
  }

  _updateAppName () {
    this.props.dispatch(updateAppName(this.refs.appName.value))
    this.props.dispatch(showSettings(false));
  }
}

export default connect(({ app, auth }) => ({ app, auth }))(Settings);
