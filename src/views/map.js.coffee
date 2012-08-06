class Backbone.Widgets.Map extends Backbone.View
  tagName: 'div'
  className: 'map'

  markers: []

  initialize: (opts) =>
    @lat        = opts.lat
    @lng        = opts.lng
    @el         = opts.el
    @collection = opts.collection

    @collection.on 'add', @createMarker

  render: =>
    latLng = new google.maps.LatLng(@lat, @lng)

    mapOptions =
      mapTypeControl: false
      overviewMapControl: false
      zoom:      14
      center:    latLng
      mapTypeId: google.maps.MapTypeId.ROADMAP
    @gmap = new google.maps.Map @el.get(0), mapOptions

    google.maps.event.addListener(@gmap, 'idle', =>)
    google.maps.event.addListener(@gmap,
                                  'bounds_changed',
                                  _.debounce(@updateCollection, 200))
    @

  close: =>
    @clearMarkers()
    google.maps.event.clearListeners(@gmap, 'idle')
    google.maps.event.clearListeners(@gmap, 'bounds_changed')
    @gmap = null
    super()

  clearMarkers: =>
    _(@markers).each (marker) =>
      marker.close()
    @markers = []

  renderMarkers: =>
    @clearMarkers()
    @collection.each @createMarker

  updateCollection: =>
    @collection.fetch
      data:
        bounds: @getBounds()
      add: true

  createMarker: (marker) =>
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
