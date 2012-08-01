#=require views/suggestions_for_input

describe 'Backbone.Widgets.SuggestionsForInput', ->
  beforeEach ->
    $(document).ajaxError (event, request, settings) ->
      # console.error "ajaxError!"
      # conso
      console.error request.responseText
      console.log event
      console.log request
      console.log settings


    loadFixtures 'backbone-widgets/suggestions_for_input'
    @input = $('input#suggestions')
    @modelClass = Backbone.Model.extend()
    @collectionClass = Backbone.Collection.extend
      model: @modelClass, url: 'some-url'
    @collection = new @collectionClass

  describe 'when setup with default options', ->
    beforeEach ->
      @view = new Backbone.Widgets.SuggestionsForInput
        el: @input
        collection: @collection
        itemRenderer: ->
      @view.render()
      @data = @input.data('autocomplete')
      @opts = @data.options

    it 'adds .has-suggestions class to input', ->
      expect(@input.hasClass('has-suggestions')).toBeTruthy()

    it 'sets source callback', ->
      expect(@opts.source).toEqual(@view.sourceCallback)

    it 'sets select callback', ->
      expect(@opts.select).toEqual(@view.selectCallback)

    describe 'integration test', ->
      beforeEach ->
        @server = sinon.fakeServer.create()

      afterEach ->
        @server.restore()

      it 'fucking works', ->
        @server.respondWith "GET", /some-url.*/, [
          200, { "Content-Type": "application/json" },
          JSON.stringify(id: 1, name: 'some name', label: 'some label')
        ]

        $.get('/some-url?term=some', -> alert 'aa')

        # @collection.fetch()
        # params = {"type":"GET","dataType":"json","url":"some-url","data":{"term":"some"},"parse":true}
        # params = {"type":"GET", "url":"/some-url"}
        # $.ajax(params)
        # @collection.fetch data: {term: 'some'}
        # @input.val('some').trigger('keydown')
        @server.respond()

        # expect(true).toBeFalsy()





  #   it 'sets _renderItem on autocomplete if options.itemRenderer provided', ->
  #     autocomplete = {}
  #     view.render()
  #     data = input.data('autocomplete')

  #     expect(data._renderItem).toEqual(itemRenderer)







  #   describe 'autocomplete settings', ->
  #     it 'minLenght should equal 3', ->
  #       view.render()
  #       lenght = input.autocomplete("option", "minLength")

  #       expect(lenght).toEqual(3)


  #   describe '@sourceCallback', ->
  #     it 'sets collection term to request.term', ->
  #       oldSetTerm = collection.setTerm
  #       collection.setTerm = sinon.spy()
  #       collection.url = '/some_url'

  #       view.sourceCallback {term: 'some term'}, sinon.stub()

  #       expect(collection.setTerm).toHaveBeenCalledWith('some term')

  #       collection.setTerm = oldSetTerm

  #     it 'calls @collection.fetch with results of @createSuccessCallback', ->
  #       collection.setTerm = sinon.stub()

  #       sinon.spy collection, 'fetch'
  #       sinon.stub view, 'createSuccessCallback', -> 'success callback'

  #       request = {term: 'some term'}
  #       response = sinon.stub()

  #       # call method
  #       view.sourceCallback(request, response)

  #       expect(collection.fetch).toHaveBeenCalledWith('success callback')

  #       view.createSuccessCallback.restore()
  #       collection.fetch.restore()

  #     it 'calls @view.createSuccessCallback with response object', ->
  #       collection.setTerm = sinon.stub()

  #       sinon.stub collection, 'fetch'
  #       sinon.spy view, 'createSuccessCallback'

  #       request = {term: 'some term'}
  #       response = sinon.stub()

  #       # call method
  #       view.sourceCallback(request, response)

  #       expect(view.createSuccessCallback).toHaveBeenCalledWith(response)

  #       view.createSuccessCallback.restore()
  #       collection.fetch.restore()

  #   describe '@createSuccessCallback result.success', ->
  #     it 'calls first argument with @collection.toJSON()', ->
  #       sinon.stub collection, 'toJSON', -> 'json string'
  #       response = sinon.spy()

  #       result = view.createSuccessCallback(response)
  #       result.success()

  #       expect(response).toHaveBeenCalledWith('json string')

















