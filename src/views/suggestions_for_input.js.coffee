#=require antykwariusz
#=require jquery-ui

class Antykwariusz.SuggestionsForInput extends Backbone.View
  initialize: (options) ->
    @collection = options.collection

  render: =>
    $(@el).addClass('has-suggestions').focus().autocomplete
      minLength: 3
      select: @selectCallback
      source: @sourceCallback

  selectCallback: (event, ui) =>
    @trigger 'select', ui.item

  sourceCallback: (request, response) =>
    @collection.setTerm request.term
    @collection.fetch @createSuccessCallback(response)

  createSuccessCallback: (response) ->
    success: => response(@collection.toJSON())



    # capybara hack
    # @$('.search input').data('autocomplete')._renderItem = (ul, item) =>
    #   button = $('<li></li>')
    #   button.data("item.autocomplete", item)
    #         .append("<a href=\"#\">#{item.label}</a>")
    #         .appendTo ul
