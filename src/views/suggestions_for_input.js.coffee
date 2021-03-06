#=require jquery-ui

class Backbone.Widgets.SuggestionsForInput extends Backbone.View
  initialize: (options) ->
    @itemRenderer = options.itemRenderer if options.itemRenderer
    @collection = options.collection

  render: =>
    options =
      minLength: 3
      select: @selectCallback
      source: @sourceCallback
      close: => @suggesting = false
      open: => @suggesting = true

    autocomplete = $(@el).addClass('has-suggestions').focus().autocomplete(options)

    if @itemRenderer
      autocomplete.data('autocomplete')._renderItem = @itemRenderer

    @

  selectCallback: (event, ui) =>
    @trigger 'select', event, ui.item

  sourceCallback: (request, response) =>
    @collection.fetch
      data:
        term: request.term
      success: @createSuccessCallback(response)

  createSuccessCallback: (response) ->
    => response(@collection.toJSON())

  isSuggesting: => @suggesting
