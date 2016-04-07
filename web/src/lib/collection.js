import _ from 'lodash';

export function curated (itemsObj) {
  return _(itemsObj)
    .map((item, id) => _.extend({}, item, { id }))
    .reject(item => item === 'lists')
    .sortBy('order')
    .value();
};
