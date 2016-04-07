const NAMESPACE = 'imalist';

export default {
  data: JSON.parse(localStorage[NAMESPACE] || '{}'),

  fetch: function(key) {
    return this.data[key];
  },

  save: function(key, value) {
    if (typeof key === 'string') {
      this.data[key] = value;
    } else {
      for (let itemKey in key) {
        value = key[itemKey];
        this.data[itemKey] = value;
      }
    }
    localStorage[NAMESPACE] = JSON.stringify(this.data);
    return value;
  }
};
