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
        <form onSubmit={this._onSubmit.bind(this)}>
          <label>App Name</label>
          <input
            ref='appName'
            placeholder='App Name'
            defaultValue={this.props.app.appName}
          />
        </form>
        <button onClick={this._toggleShowing.bind(this)}>
          <i className='fa fa-cog'></i>
        </button>
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
