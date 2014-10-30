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
      RD.ul null, _.map @props.lists, (list, id)=>
        List
          key: id
          model: new ListModel list
          onSelect: _.partial @props.onListSelect, id
          onUpdate: _.partial @props.onUpdate, id
          onRemove: _.partial @props.onRemove, id
