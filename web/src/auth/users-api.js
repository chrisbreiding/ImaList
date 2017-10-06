import firebase from '../data/firebase'

class UsersApi {
  fetchUsersData (userId) {
    return firebase.when(`users/${userId}`)
  }

  listen (userId, callback) {
    firebase.watchDoc(`users/${userId}`, ({ value: user }) => {
      callback(user)
    })
  }

  updateUser (user) {
    firebase.update(`users/${user.id}`, user)
  }
}

export default UsersApi
