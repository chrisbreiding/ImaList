import firebase from 'firebase/app'
import 'firebase/auth'
import 'firebase/database'
import Promise from 'bluebird/js/browser/bluebird.core'

import appState from '../app/app-state'

// Util

function getAuth () {
  return appState.app.auth()
}

function getRef () {
  return appState.app.database().ref()
}

// App

function init (appName, apiKey) {
  if (appState.app) appState.app.delete()

  try {
    return firebase.initializeApp({
      apiKey,
      authDomain: `${appName}.firebaseapp.com`,
      databaseURL: `https://${appName}.firebaseio.com`,
      storageBucket: `${appName}.appspot.com`,
    }, appName)
  } catch (e) {
    return null
  }
}

// Auth

function getCurrentUser () {
  return getAuth().currentUser
}

function onAuthStateChanged (callback) {
  getAuth.onAuthStateChanged(callback)
}

function signIn (email, password) {
  return getAuth().signInWithEmailAndPassword(email, password)
}

function signOut () {
  return getAuth().signOut()
}

// Events

function when (path, event) {
  return new Promise((resolve) => {
    getRef().child(path).once(event, (snapshot) => {
      resolve({
        id: snapshot.key,
        value: snapshot.val(),
      })
    })
  })
}

function whenever (path, event, callback) {
  getRef().child(path).on(event, (snapshot) => {
    callback({
      id: snapshot.key,
      value: snapshot.val(),
    })
  })
}

function whenLoaded () {
  return new Promise((resolve) => {
    getRef().once('value', resolve)
  })
}

function stop (path) {
  if (path) {
    getRef().child(path).off()
  } else {
    getRef.off()
  }
}

// Data

function add (path, value) {
  return new Promise((resolve) => {
    const newRef = getRef().child(path).push(value, () => {
      resolve(newRef.key)
    })
  })
}

function remove (path) {
  return new Promise((resolve) => {
    getRef().child(path).remove(resolve)
  })
}

function update (path, value) {
  return new Promise((resolve) => {
    getRef().child(path).update(value, resolve)
  })
}


const api = {
  init,

  getCurrentUser,
  onAuthStateChanged,
  signIn,
  signOut,

  when,
  whenever,
  whenLoaded,
  stop,

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

  #init(appName, apiKey)
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
  #whenever(path, event, callback)
  #whenLoaded()
  > Promise
  #stop(path?)
  #add(path, value)
  > Promise
  #remove(path)
  > Promise
  #update(path, value)
  > Promise

Firebase API

  #initializeApp(appDetails, appName)
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
