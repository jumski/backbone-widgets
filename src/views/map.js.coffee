#= require gmaps

class Backbone.Widgets.Map extends Backbone.View
  markers: []

  initialize: (opts) =>
    @lat = opts.lat
    @lng = opts.lng
    @el = opts.el
    @markersOpts = opts.markers

  render: =>
    if $('#map').length
      @gmap = new GMaps
        div: @$el.attr('id')
        lat: @lat
        lng: @lng

      @renderMarkers()
      @

  renderMarkers: =>
    _(@markers).each (marker) =>
      marker.close()
    @markers = []

    _(@markersOpts).each (opts) =>
      opts = _.extend(opts, {map: @})
      marker = new Backbone.Widgets.MapMarker opts
      marker.render()
      @markers.push marker
