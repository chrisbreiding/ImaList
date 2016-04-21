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

export function observeStore (selector, onChange) {
  let currentValue;

  function handleChange() {
    let nextValue = _.get(store.getState(), selector);
    if (nextValue !== currentValue) {
      currentValue = nextValue;
      onChange(currentValue);
    }
  }

  let unsubscribe = store.subscribe(handleChange);
  handleChange();
  return unsubscribe;
}
