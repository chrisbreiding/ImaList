import cs from 'classnames'
import { action } from 'mobx'
import { observer } from 'mobx-react'
import React, { Component } from 'react'

import auth from '../login/auth'
import authState from '../login/auth-state'
import listsStore from '../lists/lists-store'

import ActionSheet from '../modal/action-sheet'
import Items from '../items/items'
import Lists from '../lists/lists'

@observer
class App extends Component {
  componentWillMount () {
    listsStore.listen()
  }

  componentWillUnmount () {
    listsStore.stopListening()
  }

  render () {
    const lists = listsStore.lists()

    return (
      <div
        className={cs({
          'app': true,
          'showing-items': listsStore.showingItems,
        })}
      >
        <Lists
          lists={lists}
          onLogout={action('logout', () => authState.attemptingLogout = true)}
        />
        <Items
          list={listsStore.selectedList(lists)}
          isLoading={listsStore.isLoading}
          onShowLists={action('show:lists', () => listsStore.selectList(null))}
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
