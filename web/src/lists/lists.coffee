React = require 'react'
_ = require 'lodash'

RD = React.DOM

module.exports = React.createClass

  render: ->
    RD.ul className: 'lists', _.map @props.lists, (list, id)=>
      RD.li
        key: list.name, onClick: _.partial @props.onListSelect, id
        list.name
