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
    url: 'dummy_url'
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

  describe 'saveIfValid', ->
    beforeEach ->
      @disableSpy = sinon.spy(@form.button, 'disable')
      @enableSpy = sinon.spy(@form.button, 'enable')
      @event =
        preventDefault: sinon.spy()
        stopPropagation: sinon.spy()

    afterEach ->
      @form.commit.restore()
      @form.model.on.restore()
      @form.model.save.restore()
      @form.button.disable.restore()
      @form.button.enable.restore()

    describe 'when form is valid', ->
      beforeEach ->
        sinon.stub(@form, 'commit').returns(null)
        @onSpy   = sinon.spy(@form.model, 'on')
        @saveSpy = sinon.spy(@form.model, 'save')
        @form.saveIfValid(@event)

      it 'stops events propagation', ->
        expect(@event.stopPropagation.called).toBeTruthy()

      it 'prevents default', ->
        expect(@event.preventDefault.called).toBeTruthy()

      it 'disables the button', ->
        expect(@disableSpy.called).toBeTruthy()

      it 'binds button enable on model error', ->
        expect(@onSpy.called).toBeTruthy()

      it 'calls save with success callback', ->
        expect(@saveSpy.called).toBeTruthy()

    describe 'when form is invalid', ->
      beforeEach ->
        sinon.stub(@form, 'commit').returns({error: 'message'})


        @onSpy   = sinon.mock(@form.model, 'on')
        @saveSpy = sinon.mock(@form.model, 'save')











