import firebase from 'firebase/app'
import 'firebase/auth'
import 'firebase/database'
import 'firebase/firestore'

import appState from '../app/app-state'

// Util

function getAuth () {
  return appState.app.auth()
}

function getDb () {
  return firebase.firestore()
}

// App

function init (projectId, apiKey) {
  const ready = appState.app ? appState.app.delete() : Promise.resolve()

  return ready.then(() => {
    const app = firebase.initializeApp({
      apiKey,
      projectId,
    })

    return firebase.firestore().enablePersistence()
    .catch((err) => {
      // eslint-disable-next-line no-console
      console.log('Failed to enable offline persistence:', err)
    })
    .then(() => app)
  })
}

// Auth

function getCurrentUser () {
  return getAuth().currentUser
}

function onAuthStateChanged (callback) {
  getAuth().onAuthStateChanged(callback)
}

function signIn (email, password) {
  return getAuth().signInWithEmailAndPassword(email, password)
}

function signOut () {
  return getAuth().signOut()
}

// Events

function watchDoc (path, callback) {
  return getDb().doc(path).onSnapshot((snapshot) => {
    if (!snapshot.exists) return

    callback({
      id: snapshot.id,
      value: snapshot.data(),
    })
  })
}

function watchCollection (path, callbacks) {
  return getDb().collection(path).onSnapshot((snapshot) => {
    snapshot.docChanges.forEach((change) => {
      if (callbacks[change.type]) {
        callbacks[change.type]({
          id: change.doc.id,
          value: change.doc.data(),
        })
      }
    })
  })
}

// db.collection("users").get().then((snapshot) => {
//     snapshot.forEach((doc) => {
//         console.log(`${doc.id} => ${doc.data()}`);
//     });
// });

function when (path) {
  return getDb().doc(path).get().then((snapshot) => {
    if (!snapshot.exists) return

    return {
      id: snapshot.key,
      value: snapshot.data(),
    }
  })
}

function whenLoaded () {
  return Promise.all([
    getDb().collection('lists').get(),
    getDb().collection('users').get(),
  ])
}

// Data

function add (path, value) {
  return getDb().collection(path).add(value).then((docRef) => {
    return docRef.id
  })
}

function remove (path) {
  return getDb().doc(path).delete()
}

function update (path, value) {
  return getDb().doc(path).set(value, { merge: true })
}


const api = {
  init,

  getCurrentUser,
  onAuthStateChanged,
  signIn,
  signOut,

  watchCollection,
  watchDoc,
  when,
  whenLoaded,

  add,
  remove,
  update,
}

if (window.env === 'development' || window.env === 'test') {
  window.firebase = api
}

export default api

/**
This API

  #init(projectId, apiKey)
  > firebase.App
  #getCurrentUser()
  > firebase.User
  #onAuthStateChanged(callback)
  #signIn(email, password)
  > Promise
  #signOut()
  > Promise
  #when(path, event)
  > Promise
  #whenever(path, callbacks)
  #whenLoaded()
  > Promise
  #add(path, value)
  > Promise
  #remove(path)
  > Promise
  #update(path, value)
  > Promise

Firebase API

  #initializeApp(appDetails, projectId)
  > firebase.App
    #delete()
    #auth()
      > firebase.auth
        #onAuthStateChanged(callback)
        #signInWithEmailAndPassword(email, password)
        > Promise
        #signOut
        > Promise
        .currentUser
        > firebase.User
          .uid
          .email
    #database()
      > firebase.Database
        #ref()
        > firebase.Ref
          #child(refName)
          > firebase.Emitter
            #on(event, callback)
            #once(callback)
            #off()
            #push(object, callback)
            #update(object)
            #remove()
*/
