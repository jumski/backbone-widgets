#= require gmaps_infobox

class Backbone.Widgets.MapMarker extends Backbone.View
  markerImageDefaults:
    origin: [0, 0]
    anchor: [0, 0]
  markerShadowDefaults:
    origin: [0, 0]
    anchor: [0, 0]
  infoBoxDefaults:
    disableAutoPan: true
    # works with above set to false - it is an auto pan margin
    # infoBoxOptsClearance: new google.maps.Size(10, 10)
    zIndex: null
    isHidden: false
    enableEventPropagation: false

  initialize: (opts) =>
    @title = opts.title
    @lat   = opts.lat
    @lng   = opts.lng
    @map   = opts.map

    if opts.markerImage
      @markerImageOpts = _.extend({}, @markerImageDefaults, opts.markerImage)
      if opts.markerShadow
        @markerShadowOpts = _.extend({}, @markerShadowDefaults, opts.markerShadow)

    if opts.infoBox
      @infoBoxOpts = _.extend({}, @infoBoxDefaults, opts.infoBox)

  render: =>
    markerOpts =
      position: new google.maps.LatLng(@lat, @lng)
      map: @map.getGmap()
      title: @title

    # initialize image/shadow
    if @markerImageOpts
      markerOpts.icon = new google.maps.MarkerImage(
        @markerImageOpts.url,
        new google.maps.Size(@markerImageOpts.size...),
        new google.maps.Point(@markerImageOpts.origin...),
        new google.maps.Point(@markerImageOpts.anchor...),
      )

      if @markerShadowOpts
        markerOpts.shadow = new google.maps.MarkerImage(
          @markerShadowOpts.url,
          new google.maps.Size(@markerShadowOpts.size...),
          new google.maps.Point(@markerShadowOpts.origin...),
          new google.maps.Point(@markerShadowOpts.anchor...),
        )

    # create marker object
    @marker = new google.maps.Marker(markerOpts)

    # initialize infoBox
    if @infoBoxOpts
      @infoBox = new InfoBox(@infoBoxOpts)
      google.maps.event.addListener(@marker, 'mouseover', _.debounce(@showInfoBox))
      google.maps.event.addListener(@marker, 'mouseout', _.debounce(@hideInfoBox))

  close: =>
    google.maps.event.clearListeners(@marker, 'mouseover')
    google.maps.event.clearListeners(@marker, 'mouseout')
    @marker.setMap(null)
    @marker = null
    super()

  showInfoBox: (event) =>
    @infoBox.open(@map.getGmap(), @marker)

  hideInfoBox: =>
    @infoBox.close()
