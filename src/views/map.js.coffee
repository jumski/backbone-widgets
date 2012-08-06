class Backbone.Widgets.Map extends Backbone.View
  markers: []
  tagName: 'div'
  className: 'map'
  attributes:
    id: 'gmaps'

  @timeoutId = null

  initialize: (opts) =>
    @lat = opts.lat
    @lng = opts.lng
    @el = opts.el
    @markersOpts = opts.markers
    @collection = opts.collection
    @collection.on 'reset', @renderMarkers

  render: =>
    latLng = new google.maps.LatLng(@lat, @lng)
    console.log JSON.stringify(latLng)

    mapOptions =
      mapTypeControl: false
      overviewMapControl: false
      zoom:      14
      center:    latLng
      mapTypeId: google.maps.MapTypeId.ROADMAP
    @gmap = new google.maps.Map @el.get(0), mapOptions

    google.maps.event.addListener @gmap, 'idle', =>
    google.maps.event.addListener @gmap, 'bounds_changed', =>
      clearTimeout(@timeoutId) if @timeoutId
      @timeoutId = setTimeout @updateCollection, 200

    @

  renderMarkers: =>
    _(@markers).each (marker) =>
      marker.close()
    @markers = []

    @collection.each (marker) =>
      opts =
        title: marker.getTitle()
        lat: marker.getLatitude()
        lng: marker.getLongitude()
        color: if marker instanceof TurnYourTime.Models.Offer
                 'red'
               else
                 'blue'
        gmap: @gmap

      marker = new Backbone.Widgets.MapMarker opts
      marker.render()
      @markers.push marker

  updateCollection: =>
    @collection.fetch
      data:
        bounds: @getBounds()

  getBounds: =>
    bounds = @gmap.getBounds()

    lats = [ bounds.getNorthEast().lat(),
             bounds.getSouthWest().lat() ]
    lngs = [ bounds.getNorthEast().lng(),
             bounds.getSouthWest().lng() ]

    return {
      min_lat: _(lats).min()
      min_lng: _(lngs).min()
      max_lat: _(lats).max()
      max_lng: _(lngs).max()
    }
