#= require jquery.geocomplete

class Backbone.Widgets.Geocomplete extends Backbone.Form.editors.Base
  tagName: 'div'
  defaultValue: ''
  attributes:
    style: 'width: 600px'

  formatted_address: null
  geocodes: {}

  initialize: (options) =>
    super(options)

    @setValue(@value)

  # backbone form interface
  getValue: =>
    @geocodes

  setValue: (value) =>
    @formatted_address = value

  # view methods
  render: =>
    @$el.html HandlebarsTemplates['geocomplete']()

    @$el.find('input.geocomplete').geocomplete
      map: @$el.find('.map-canvas')
      location: @formatted_address
    @$el.on 'geocode:result', (event, result) =>
      @geocodes =
        formatted_address: result.formatted_address
        latitude: result.geometry.location.$a
        longitude: result.geometry.location.ab

      console.log @geocodes

      # console.log result
      # console.log result.formatted_address
      # console.log result.geometry.location.$a
      # console.log result.geometry.location.ab

    @
