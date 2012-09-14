class Backbone.Widgets.Map extends Backbone.View
  tagName: 'div'
  className: 'map'

  markers: []
  isInfoBoxPinned: false

  initialize: (opts) =>
    @lat = opts.lat
    @lng = opts.lng
    @el  = opts.el

  render: =>
    latLng = new google.maps.LatLng(@lat, @lng)

    mapOptions =
      mapTypeControl: false
      overviewMapControl: false
      zoom:      14
      center:    latLng
      mapTypeId: google.maps.MapTypeId.ROADMAP
    @gmap = new google.maps.Map @el.get(0), mapOptions

    google.maps.event.addListener(@gmap, 'idle', ->)
    google.maps.event.addListener(@gmap, 'bounds_changed',
                                  => @trigger('bounds_changed', @getBounds()))
    @

  close: =>
    @clearMarkers()
    @off 'bounds_changed'
    google.maps.event.clearListeners(@gmap, 'idle')
    google.maps.event.clearListeners(@gmap, 'bounds_changed')
    @gmap = null
    super()

  clearMarkers: =>
    _(@markers).each (marker) =>
      marker.close()
    @markers = []

  createMarker: (markerOpts) =>
    marker = new Backbone.Widgets.MapMarker(markerOpts)
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

  getGmap: => @gmap
