NAMESPACE = 'imalist'

module.exports =

  data: JSON.parse localStorage[NAMESPACE] or '{}'

  fetch: (key)->
    @data[key]

  save: (key, value)->
    if typeof key is 'string'
      @data[key] = value
    else
      for itemKey, value of key
        @data[itemKey] = value
    localStorage[NAMESPACE] = JSON.stringify @data
    value
