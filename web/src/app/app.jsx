import cs from 'classnames';
import _ from 'lodash';
import React, { createClass } from 'react';
import ReactFireMixin from 'reactfire';

import ActionSheet from '../action-sheet/action-sheet';
import { curated } from '../lib/collection';
import Items from '../items/items';
import ItemModel from '../items/item-model';
import Lists from '../lists/lists';
import ListModel from '../lists/list-model';
import store from '../lib/store';

export default createClass({
  displayName: 'App',

  mixins: [ReactFireMixin],

  getInitialState () {
    return {
      lists: [],
      showItems: store.fetch('showItems') || false,
      actionSheetProps: {},
      selectedListId: store.fetch('selectedListId') || null,
    };
  },

  componentWillMount () {
    this.bindAsObject(this.props.firebaseRef.child('lists'), 'lists');
  },

  componentDidUpdate () {
    store.save({
      selectedListId: this.state.selectedListId,
      showItems: this.state.showItems
    });
  },

  render () {
    const lists = this._curatedLists(this.state.lists, this.props.userEmail);
    const selectedList = this._selectedList(lists);

    return (
      <div
        className={cs({
          'app': true,
          'showing-items': this.state.showItems
        })}
      >
        <Lists
          ref='lists'
          lists={lists}
          selectedListId={selectedList.id}
          userEmail={this.props.userEmail}
          onLogout={this._logout}
          onAdd={this._addList}
          onListSelect={this._showItems}
          onUpdate={this._listUpdated}
          onRemove={this._listRemoved}
        />
        <Items
          ref='items'
          listName={selectedList.name}
          items={selectedList.items}
          onShowLists={this._showLists}
          onAdd={this._addItem}
          onUpdate={this._itemUpdated}
          onRemove={this._itemRemoved}
          onClearCompleted={this._clearCompleted}
        />
        <ActionSheet {...this.state.actionSheetProps} />
      </div>
    );
  },

  _logout () {
    const actionSheetProps = {
      confirmMessage: 'Logout',
      onConfirm: () => {
        this._removeActionSheet(() => this.props.onLogout());
      },
      onCancel: () => this._removeActionSheet(),
    };
    this.setState({ actionSheetProps });
  },

  _curatedLists (lists, userEmail) {
    return ListModel.approvedForUser(curated(lists), userEmail);
  },

  _selectedList (lists) {
    const userSelectedId = this.state.selectedListId || null;
    const fallbackId = lists[0] && lists[0].id;
    const selectedListId = userSelectedId || fallbackId;

    const selected = _.find(lists, { id: selectedListId });
    const fallback = _.find(lists, { id: fallbackId });

    return selected || fallback || { items: {} };
  },

  _showItems (id) {
    this.setState({
      showItems: true,
      selectedListId: id
    });
  },

  _showLists () {
    return this.setState({ showItems: false });
  },

  _add (type, ref, items, Model) {
    if (!items || !Object.keys(items).length) {
      this._addWithOrder(type, ref, Model, 0);
      return;
    }

    const order = this._lastOrder(items) + 1;
    return this._addWithOrder(type, ref, Model, order);
  },

  _lastOrder (items) {
    return Math.max.apply(Math, _.map(items, 'order'));
  },

  _addWithOrder (type, ref, Model, order) {
    const newRef = ref.push(new Model({ order, owner: this.props.userEmail }), () => {
      this.refs[type].edit(newRef.key());
    });

    return newRef;
  },

  _addList () {
    const lists = _.reject(this.state.lists, (__, key) => key === '.key');
    this._add('lists', this.firebaseRefs.lists, lists, ListModel);
  },

  _listUpdated (id, list) {
    this.firebaseRefs.lists.child(id).update(list);
  },

  _listRemoved (id) {
    const actionSheetProps = {
      confirmMessage: 'Remove List',
      onConfirm: () => {
        this.firebaseRefs.lists.child(id).remove();
        this._removeActionSheet();
      },
      onCancel: () => this._removeActionSheet(),
    };

    return this.setState({ actionSheetProps });
  },

  _addItem () {
    const ref = this.firebaseRefs.lists.child(`${this.state.selectedListId}/items/`);
    const items = this.state.lists[this.state.selectedListId].items || {};
    this._add('items', ref, items, ItemModel);
  },

  _itemUpdated (id, item) {
    const itemRef = this.firebaseRefs.lists.child(`${this.state.selectedListId}/items/${id}`);
    itemRef.update(item);
  },

  _itemRemoved (id) {
    const itemRef = this.firebaseRefs.lists.child(`${this.state.selectedListId}/items/${id}`);
    itemRef.remove();
  },

  _clearCompleted () {
    const actionSheetProps = {
      confirmMessage: 'Clear Completed',
      onConfirm: () => {
        _.each(this.state.lists[this.state.selectedListId].items, (item, id) => {
          if (item.isChecked) {
            this._itemRemoved(id);
          }
        });
        this._removeActionSheet();
      },
      onCancel: () => this._removeActionSheet(),
    };
    this.setState({ actionSheetProps });
  },

  _removeActionSheet (callback) {
    this.setState({ actionSheetProps: null }, callback);
  },
});
