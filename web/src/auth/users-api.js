import { action } from 'mobx'
import Promise from 'bluebird/js/browser/bluebird.core'

import firebase from '../data/firebase'

class UsersApi {
  fetchUsersData () {
    return new Promise((resolve) => {
      firebase.getRef().child('users').once('value', (childSnapshot) => {
        resolve(childSnapshot.val())
      })
    })
  }

  listen ({ onUpdate }) {
    firebase.getRef().child('users').on('value', action('users:updated', (childSnapshot) => {
      onUpdate(childSnapshot.val())
    }))
  }

  updateUser (user) {
    firebase.getRef().child(`users/${user.id}`).update(user)
  }
}

export default UsersApi
