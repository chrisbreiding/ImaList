import C from '../data/constants';

export default function (state = {}, action = {}) {
  switch (action.type) {
    case C.LISTS_UPDATED:
      return action.lists || {};
    default:
      return state;
  }
};
