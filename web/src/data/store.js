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
export default createStoreWithMiddleware(rootReducer);
