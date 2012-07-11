#=require views/suggestions_for_input

describe 'Antykwariusz.SuggestionsForInput', ->
  # loadFixtures 'suggestions_for_input.html'
  modelUrl = '/model_url'
  model = new Backbone.Model url: modelUrl
  collection = new Backbone.Collection model: model
  fixture = $('<div><input type="text" /></div>')
  input = $('input', fixture)
  itemRenderer = (ul, item) ->
  view = new Antykwariusz.SuggestionsForInput
    el: input, collection: collection, itemRenderer: itemRenderer

  oldRender = Antykwariusz.SuggestionsForInput::render
  afterEach ->
    Antykwariusz.SuggestionsForInput::render = oldRender

  describe '#render', ->
    it 'adds .has-suggestions class to input', ->
      view.render()
      expect(input.hasClass('has-suggestions')).toBeTruthy()

    it 'calls focus() on passed element', ->
      mock = sinon.mock($.fn)
      mock.expects("focus").once().returns(input)

      view.render()
      mock.verify()

    it 'calls autocomplete() on passed element', ->
      mock = sinon.mock($.fn)
      mock.expects("autocomplete").once().returns(input)

      view.render()
      mock.verify()

    it 'sets _renderItem on autocomplete if options.itemRenderer provided', ->
      autocomplete = {}
      view.render()
      data = input.data('autocomplete')

      expect(data._renderItem).toEqual(itemRenderer)

    describe 'autocomplete settings', ->
      it 'minLenght should equal 3', ->
        view.render()
        lenght = input.autocomplete("option", "minLength")

        expect(lenght).toEqual(3)

      it 'select should equal view.selectCallback', ->
        select = input.autocomplete("option", "select")
        expect(select).toEqual(view.selectCallback)

      it 'source should equal view.sourceCallback', ->
        source = input.autocomplete("option", "source")
        expect(source).toEqual(view.sourceCallback)

    describe '@selectCallback', ->
      it 'triggers :select event with ui.item', ->
        oldTrigger = view.trigger
        view.trigger = sinon.spy()

        view.selectCallback('some event', {item: 'some item'})

        expect(view.trigger).toHaveBeenCalledWith('select', 'some item')

        view.trigger = oldTrigger

    describe '@sourceCallback', ->
      it 'sets collection term to request.term', ->
        oldSetTerm = collection.setTerm
        collection.setTerm = sinon.spy()
        collection.url = '/some_url'

        view.sourceCallback {term: 'some term'}, sinon.stub()

        expect(collection.setTerm).toHaveBeenCalledWith('some term')

        collection.setTerm = oldSetTerm

      it 'calls @collection.fetch with results of @createSuccessCallback', ->
        collection.setTerm = sinon.stub()

        sinon.spy collection, 'fetch'
        sinon.stub view, 'createSuccessCallback', -> 'success callback'

        request = {term: 'some term'}
        response = sinon.stub()

        # call method
        view.sourceCallback(request, response)

        expect(collection.fetch).toHaveBeenCalledWith('success callback')

        view.createSuccessCallback.restore()
        collection.fetch.restore()

      it 'calls @view.createSuccessCallback with response object', ->
        collection.setTerm = sinon.stub()

        sinon.stub collection, 'fetch'
        sinon.spy view, 'createSuccessCallback'

        request = {term: 'some term'}
        response = sinon.stub()

        # call method
        view.sourceCallback(request, response)

        expect(view.createSuccessCallback).toHaveBeenCalledWith(response)

        view.createSuccessCallback.restore()
        collection.fetch.restore()

    describe '@createSuccessCallback result.success', ->
      it 'calls first argument with @collection.toJSON()', ->
        sinon.stub collection, 'toJSON', -> 'json string'
        response = sinon.spy()

        result = view.createSuccessCallback(response)
        result.success()

        expect(response).toHaveBeenCalledWith('json string')

















