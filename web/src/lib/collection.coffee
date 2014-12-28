_ = require 'lodash'

module.exports = class Collection

  @curated: (itemsObj)->
    @_order @_toArray itemsObj

  @_toArray: (itemsObj)->
    _.map itemsObj, (item, id)->
      item.id = id
      item

  @_order: (items)->
    _.sortBy items, 'order'
