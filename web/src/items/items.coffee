React = require 'react'
_ = require 'lodash'

RD = React.DOM

module.exports = React.createClass

  render: ->
    RD.ul className: 'items', _.map @props.items, (item)->
      RD.li key: item.name,
        item.name
