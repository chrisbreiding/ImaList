_ = require 'lodash'

module.exports = class Collection

  @curated: (itemsObj)->
    @_ordered @_toArray itemsObj

  @_toArray: (itemsObj)->
    _.map itemsObj, (item, id)->
      item.id = id
      item

  @_ordered: (items)->
    _.sortBy items, 'order'
