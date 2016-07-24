import cs from 'classnames'
import { action } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

import auth from '../login/auth'
import authState from '../login/auth-state'
import ListsStore from '../lists/lists-store'

import ActionSheet from '../modal/action-sheet'
import Items from '../items/items'
import Lists from '../lists/lists'

@observer
class App extends Component {
  componentWillMount () {
    this.listsStore = new ListsStore()
    this.listsStore.listen()
  }

  componentWillUnmount () {
    this.listsStore.stopListening()
  }

  render () {
    return (
      <div
        className={cs({
          'app': true,
          'showing-items': this.listsStore.showingItems,
        })}
      >
        <Lists
          listsStore={this.listsStore}
          onLogout={action('logout', () => authState.attemptingLogout = true)}
        />
        <Items
          list={this.listsStore.selectedList}
          isLoading={this.listsStore.isLoading}
          onShowLists={action('show:lists', () => this.listsStore.selectList(null))}
        />
        {this._confirmLogout()}
      </div>
    )
  }

  _confirmLogout () {
    return (
      <ActionSheet
        isShowing={authState.attemptingLogout}
        confirmMessage='Logout'
        onConfirm={action('logout:confirmed', () => auth.logout())}
        onCancel={action('logout:cancelled', () => authState.attemptingLogout = false)}
      />
    )
  }
}

export default App
