import _ from 'lodash';
import { createStore, combineReducers, applyMiddleware } from 'redux';
import thunkMiddleware from 'redux-thunk';

import auth from '../login/auth-reducer';
import app from '../app/app-reducer';
import lists from '../lists/lists-reducer';

// const logger = ({ getState }) => (next) => (action) => {
//   console.log(getState());
//   return next(action);
// };

const createStoreWithMiddleware = applyMiddleware(thunkMiddleware)(createStore);
const rootReducer = combineReducers({ auth, app, lists });

export const store = createStoreWithMiddleware(rootReducer);

export function observeStore (selectors, onChange) {
  selectors = [].concat(selectors)
  let currentValues = [];

  function handleChange () {
    const state = store.getState();
    const nextValues = _.map(selectors, (selector) =>  _.get(state, selector));
    if (!_.isEqual(currentValues, nextValues)) {
      currentValues = nextValues
      onChange(...currentValues);
    }
  }

  let unsubscribe = store.subscribe(handleChange);
  handleChange();
  return unsubscribe;
}
