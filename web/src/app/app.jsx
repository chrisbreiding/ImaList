import cs from 'classnames';
import React, { Component } from 'react';
import { connect } from 'react-redux';

import { attemptLogout, logout } from '../login/auth-actions';
import { listen, stopListening } from '../app/app-actions';
import { selectList } from '../lists/lists-actions';

import ActionSheet from '../action-sheet/action-sheet';
import Items from '../items/items';
import Lists from '../lists/lists';

class App extends Component {
  componentWillMount () {
    listen(this.props.dispatch);
  }

  componentWillUnmount () {
    stopListening();
  }

  render () {
    const { app, auth, dispatch, lists } = this.props;
    const selectedList = lists[app.selectedListId] || {};

    return (
      <div
        className={cs({
          'app': true,
          'showing-items': app.showItems
        })}
      >
        <Lists
          lists={lists}
          selectedListId={app.selectedListId}
          isLoading={app.loadingData}
          userEmail={auth.email}
          onLogout={() => dispatch(attemptLogout(true))}
        />
        <Items
          list={selectedList}
          items={selectedList.items}
          isLoading={app.loadingData}
          onShowLists={() => dispatch(selectList())}
        />
        {this._confirmLogout()}
      </div>
    );
  }

  _confirmLogout () {
    if (!this.props.auth.attemptingLogout) return null;

    return (
      <ActionSheet
        confirmMessage='Logout'
        onConfirm={() => this.props.dispatch(logout())}
        onCancel={() => this.props.dispatch(attemptLogout(false))}
      />
    );
  }
}

export default connect(({ auth, app, lists }) => ({ auth, app, lists }))(App);
