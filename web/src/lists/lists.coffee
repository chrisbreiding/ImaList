React = require 'react/addons'
_ = require 'lodash'
List = React.createFactory require './list'
ListModel = require './list-model'

RD = React.DOM

module.exports = React.createClass

  render: ->
    RD.div className: 'lists',
      RD.header null,
        RD.h1 null, 'ImaList'
      RD.ul null, _.map ListModel.curated(@props.lists), (list)=>
        id = list.id
        List
          key: id
          ref: id
          model: new ListModel list
          onSelect: _.partial @props.onListSelect, id
          onUpdate: _.partial @props.onUpdate, id
          onRemove: _.partial @props.onRemove, id
      RD.footer null,
        RD.button onClick: @props.onAdd,
          RD.i className: 'fa fa-plus'

  edit: (id)->
    @refs[id].edit()
