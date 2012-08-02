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
      zoom_changed: (x,y)->
        @collection.fetch data:
          min_lat: @map.minLat()
          max_lat: @map.maxLat()
          min_lng: @map.minLng()
          max_lng: @map.maxLng()

      dragend: (x,y)->
        console.log x
        console.log y
        console.log @

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
