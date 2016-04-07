import _ from 'lodash';

export default class List {
  constructor ({ order, owner, name = '', items = {}, shared = false }) {
    this.order = order;
    this.name = name;
    this.items = items;
    this.owner = owner;
    this.shared = shared;
  }
};

List.approvedForUser = function(lists, userEmail) {
  return _.filter(lists, function(list) {
    return list.shared || list.owner === userEmail;
  });
};
