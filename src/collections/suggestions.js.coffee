
class Backbone.Widgets.Suggestions extends Backbone.Collection
  initialize: (options) ->
    @term = ' '
    @model = options.model
    @modelUrl = (new @model).url

  url: => "#{@modelUrl}?term=#{@term}"

  setTerm: (term) =>
    @term = term

