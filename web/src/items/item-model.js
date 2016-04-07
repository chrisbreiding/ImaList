export default class Item {
  constructor ({ order, name = '', isChecked = false }) {
    this.order = order;
    this.name = name;
    this.isChecked = isChecked;
  }

  toggleChecked () {
    this.isChecked = !this.isChecked;
  };
}
