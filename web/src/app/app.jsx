import cs from 'classnames'
import { action, autorun } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

import auth from '../auth/auth'
import authState from '../auth/auth-state'
import ListsStore from '../lists/lists-store'

import ActionSheet from '../modal/action-sheet'
import Items from '../items/items'
import Lists from '../lists/lists'
import Passcode from '../auth/passcode'

@observer
class App extends Component {
  componentWillMount () {
    // move listsStore.isLoading to local state this.isLoading ?
    // and say data.loadData.then(() => {}) ?
    this.listsStore = new ListsStore()
    this.listsStore.listen()

    auth.fetchUserData().then(() => {
      auth.listenForUserDataChanges()
    })

    autorun(() => {
      console.log(authState.user.id)
    })
    autorun(() => {
      console.log(authState.user.email)
    })
    autorun(() => {
      console.log(authState.user.passcode)
    })
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
        {this._passcode()}
        {this._confirmLogout()}
      </div>
    )
  }

  _passcode () {
    if (!authState.passcodeAction) {
      return null
    }

    return <Passcode />
  }

  _confirmLogout () {
    return (
      <ActionSheet
        isShowing={authState.attemptingLogout}
        actions={[
          {
            label: 'Log Out',
            handler: action('logout:confirmed', () => auth.logout()),
          }, {
            label: 'Cancel',
            handler: action('logout:cancelled', () => authState.attemptingLogout = false),
            type: 'cancel',
          },
        ]}
      />
    )
  }
}

export default App
