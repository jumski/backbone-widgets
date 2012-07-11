#=require views/form

describe 'Backbone.Widgets.Form', ->
  # loadFixtures 'backbone-widgets/'
  # modelUrl = '/model_url'
  # model = new Backbone.Model url: modelUrl
  # collection = new Backbone.Collection model: model
  # fixture = $('<div><input type="text" /></div>')
  # input = $('input', fixture)
  # itemRenderer = (ul, item) ->
  # view = new Backbone.Widgets.SuggestionsForInput
  #   el: input, collection: collection, itemRenderer: itemRenderer

  # oldRender = Backbone.Widgets.SuggestionsForInput::render
  # afterEach ->
  #   Backbone.Widgets.SuggestionsForInput::render = oldRender

  DummyModel = Backbone.Model.extend
    schema:
      title:
        type: 'Text'

  beforeEach ->
    @model = new DummyModel
    @buttonOptions = label: 'some label', loadingLabel: 'some loading label'
    @form = new Backbone.Widgets.Form model: @model, button: @buttonOptions

  it 'is a Backbone.Form object', ->
    expect(@form).toEqual jasmine.any(Backbone.Form)

  it 'declares button click event', ->
    expect(@form.events).toEqual
      'click button' : 'saveIfValid'

  describe 'has AnimatedButton', ->
    beforeEach ->
      @button = @form.button

    it 'initializes proper object', ->
      expect(@button).toEqual jasmine.any(Backbone.Widgets.AnimatedButton)

    it 'passes options', ->
      expect(@button.label).toEqual @buttonOptions.label
      expect(@button.loadingLabel).toEqual @buttonOptions.loadingLabel
