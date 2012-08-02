#= require gmaps

class Backbone.Widgets.Map extends Backbone.View
  markers: []
  tagName: 'div'
  className: 'map'
  attributes:
    id: 'gmaps'

  initialize: (opts) =>
    @lat = opts.lat
    @lng = opts.lng
    @el = opts.el
    @markersOpts = opts.markers
    @collection = opts.collection
    @collection.on 'change', @renderMarkers

  render: =>
    @gmap = new GMaps
      div: @$el.attr('id')
      lat: @lat
      lng: @lng
      zoom_changed: @updateCollection
      dragend: @updateCollection

    window.map = @

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

  updateCollection: =>
    @collection.fetch data: @getBounds()

  getBounds: =>
    bounds = @gmap.map.getBounds()

    return {
      ne:
        lat: bounds.getNorthEast().lat()
        lng: bounds.getNorthEast().lng()
      sw:
        lat: bounds.getSouthWest().lat()
        lng: bounds.getSouthWest().lng()
    }
