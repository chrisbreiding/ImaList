import cs from 'classnames';
import _ from 'lodash';
import React, { Component } from 'react';
import { connect } from 'react-redux';

import { attemptLogout, logout } from '../login/auth-actions';
import { listen, stopListening } from '../app/app-actions';
import { selectList } from '../lists/lists-actions';

import ActionSheet from '../modal/action-sheet';
import Items from '../items/items';
import Lists from '../lists/lists';

function curatedLists (lists, auth) {
  return _(lists)
    .map((list, id) => _.extend(list, { id }))
    .sortBy('order')
    .filter((list) => list.shared || list.owner === auth.email)
    .value();
}

class App extends Component {
  componentWillMount () {
    listen(this.props.app.firebaseApp, this.props.dispatch);
  }

  componentWillUnmount () {
    stopListening(this.props.app.firebaseApp);
  }

  render () {
    const { app, auth, dispatch } = this.props;
    const lists = curatedLists(this.props.lists, auth);
    const selectedList = this._selectedList(lists);

    return (
      <div
        className={cs({
          'app': true,
          'showing-items': app.showingItems,
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

  _selectedList (lists) {
    const userSelectedId = this.props.app.selectedListId || null;
    const fallbackId = lists[0] && lists[0].id;
    const selectedListId = userSelectedId || fallbackId;

    const selected = _.find(lists, { id: selectedListId });
    const fallback = _.find(lists, { id: fallbackId });

    return selected || fallback || { items: {} };
  }

  _confirmLogout () {
    return (
      <ActionSheet
        isShowing={this.props.auth.attemptingLogout}
        confirmMessage='Logout'
        onConfirm={() => this.props.dispatch(logout(this.props.app.firebaseApp))}
        onCancel={() => this.props.dispatch(attemptLogout(false))}
      />
    );
  }
}

export default connect(({ auth, app, lists }) => ({ auth, app, lists }))(App);
