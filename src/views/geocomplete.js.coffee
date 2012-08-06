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
    @geocodes = value

  # view methods
  render: =>
    @$el.html HandlebarsTemplates['geocomplete']()

    opts = map: @$el.find('.map-canvas')
    if @geocodes.address?
      opts['location'] = @geocodes.address

    @$el.find('input.geocomplete').geocomplete(opts)
    @$el.on 'geocode:result', (event, result) =>
      postal_code_component = _(result.address_components).find (component) ->
        component.types[0] == 'postal_code'

      @geocodes =
        zip_code: if postal_code_component?.short_name?
                    postal_code_component.short_name
                  else
                    null
        latitude: result.geometry.location.lat()
        longitude: result.geometry.location.lng()
        address: result.formatted_address

    @
