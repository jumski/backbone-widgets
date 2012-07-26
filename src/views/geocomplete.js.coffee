#= require jquery.geocomplete

class Backbone.Widgets.Geocomplete extends Backbone.Form.editors.Base
  tagName: 'div'
  defaultValue: ''
  attributes:
    style: 'width: 600px'

  initialize: (options) =>
    super(options)

    @setValue(@value)

  # backbone form interface
  getValue: =>
    @$el.val()

  setValue: (value) =>
    @$el.val(value)

  # view methods
  render: =>
    @$el.html HandlebarsTemplates['geocomplete']()

    @$el.find('input.geocomplete').geocomplete
      map: @$el.find('.map-canvas')
      # location: 'NYC'
    @$el.on 'geocode:result', (event, result) =>
      console.log result
      console.log result.formatted_address
      console.log result.geometry.location.$a
      console.log result.geometry.location.ab

    @
