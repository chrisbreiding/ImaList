React = require 'react/addons'
_ = require 'lodash'

RD = React.DOM

module.exports = React.createClass

  render: ->
    RD.div className: 'lists',
      RD.header null,
        RD.h1 null, 'ImaList'
      RD.ul null, _.map @props.lists, (list, id)=>
        RD.li
          key: list.name, onClick: _.partial @props.onListSelect, id
          list.name
