const NAMESPACE = 'imalist';

export default {
  data: JSON.parse(localStorage[NAMESPACE] || '{}'),

  get (key) {
    return this.data[key];
  },

  set (key, value) {
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
  },
};
