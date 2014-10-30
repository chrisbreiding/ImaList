React = require 'react/addons'
_ = require 'lodash'
List = React.createFactory require './list'

RD = React.DOM

module.exports = React.createClass

  render: ->
    RD.div className: 'lists',
      RD.header null,
        RD.h1 null, 'ImaList'
      RD.ul null, _.map @props.lists, (list, id)=>
        List
          key: list.name
          name: list.name
          onSelect: _.partial @props.onListSelect, id
