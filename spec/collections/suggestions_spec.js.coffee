#=require collections/suggestions

describe 'Backbone.Widgets.Suggestions', ->
  model = Backbone.Model.extend url: 'model_url'
  suggestions = new Backbone.Widgets.Suggestions model: model

  it 'makes url using model.url and term', ->
    suggestions.setTerm 'some_term'
    expect(suggestions.url()).toEqual 'model_url?term=some_term'






