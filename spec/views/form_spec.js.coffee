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
      @enableSpy  = sinon.spy(@form.button, 'enable')
      @onSpy      = sinon.spy(@form.model, 'on')
      @saveSpy    = sinon.spy(@form.model, 'save')
      @event =
        preventDefault: sinon.spy()
        stopPropagation: sinon.spy()

    afterEach ->
      @form.model.on.restore()
      @form.model.save.restore()
      @form.button.disable.restore()
      @form.button.enable.restore()

    # it 'stops events propagation', ->
    #   @form.saveIfValid(@event)
    #   expect(@event.stopPropagation.called).toBeTruthy()

  #   it 'prevents default', ->
  #     @form.saveIfValid(@event)
  #     expect(@event.preventDefault.called).toBeTruthy()

  #   describe 'when form is valid', ->
  #     beforeEach ->
  #       sinon.stub(@form, 'commit').returns(null)
  #       @form.saveIfValid(@event)
  #     afterEach ->
  #       @form.commit.restore()

  #     it 'disables the button', ->
  #       expect(@disableSpy.called).toBeTruthy()

  #     it 'binds button enable on model error', ->
  #       expect(@onSpy.called).toBeTruthy()
  #       expect(@onSpy.args[0][0]).toEqual 'error'
  #       expect(@onSpy.args[0][1]).toEqual @form.button.enable

  #     it 'calls save with success callback', ->
  #       expect(@saveSpy.called).toBeTruthy()
  #       expect(@saveSpy.args[0][0]).toEqual success: @form.button.enable

  #   describe 'when form is invalid', ->
  #     beforeEach ->
  #       sinon.stub(@form, 'commit').returns({error: 'message'})
  #       @form.saveIfValid(@event)
  #     afterEach ->
  #       @form.commit.restore()

  #     it 'does not disable the button', ->
  #       expect(@disableSpy.called).toBeFalsy()

  #     it 'does not binds anything on model', ->
  #       expect(@onSpy.called).toBeFalsy()

  #     it 'does not call save on model', ->
  #       expect(@saveSpy.called).toBeFalsy()











