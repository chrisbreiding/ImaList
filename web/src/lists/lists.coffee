React = require 'react/addons'
_ = require 'lodash'
List = React.createFactory require './list'
ListModel = require './list-model'
SortableList = React.createFactory require '../lib/sortable-list'

RD = React.DOM
cs = React.addons.classSet

module.exports = React.createClass
  displayName: 'Lists'

  getInitialState: ->
    editing: false

  render: ->
    RD.div
      className: cs
        'lists': true
        'editing': @state.editing
      RD.header null,
        RD.h1 null, 'ImaList'
        RD.button className: 'edit', onClick: @_toggleEditing,
          if @state.editing then RD.span null, 'Done' else RD.i className: 'fa fa-sort'
      SortableList
        el: 'ul'
        handleClass: 'sort-handle'
        onSortingUpdate: (ids)=>
          _.each ids, (id, index)=>
            @props.onUpdate id, order: index
      , _.map @props.lists, (list)=>
        id = list.id
        List
          key: id
          ref: id
          id: id
          model: new ListModel list
          isOwner: list.owner is @props.userEmail
          isSelected: id is @props.selectedListId
          onSelect: _.partial @props.onListSelect, id
          onUpdate: _.partial @props.onUpdate, id
          onRemove: _.partial @props.onRemove, id
      RD.footer null,
        RD.button onClick: @props.onAdd,
          RD.i className: 'fa fa-plus'
        RD.button
          className: 'logout'
          onClick: @props.onLogout
          RD.i className: 'fa fa-sign-out'

  edit: (id)->
    @refs[id].edit()

  _toggleEditing: ->
    @_setEditing !@state.editing

  _setEditing: (editing)->
    @setState { editing }
