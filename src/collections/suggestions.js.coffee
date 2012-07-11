#=require antykwariusz
#=require jquery-ui

class Antykwariusz.Suggestions extends Backbone.Collection
  initialize: (options) ->
    @term = ' '
    @model = options.model
    @modelUrl = (new @model).url

  url: => "#{@modelUrl}?term=#{@term}"

  setTerm: (term) =>
    @term = term

