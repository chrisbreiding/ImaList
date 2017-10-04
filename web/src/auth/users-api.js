import { action } from 'mobx'

import firebase from '../data/firebase'

class UsersApi {
  fetchUsersData () {
    return firebase.when('users', 'value')
  }

  listen ({ onUpdate }) {
    firebase.whenever('users', 'value', action('users:updated', ({ value: users }) => {
      onUpdate(users)
    }))
    firebase.whenever('users', 'child_removed', action('users:removed', () => {
      onUpdate({})
    }))
  }

  updateUser (user) {
    firebase.update(`users/${user.id}`, user)
  }
}

export default UsersApi
