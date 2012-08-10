#= require gmaps_infobox

class Backbone.Widgets.MapMarker extends Backbone.View
  defaultMarkerImage:
    origin: [0, 0]
    anchor: [0, 0]
  defaultMarkerShadow:
    origin: [0, 0]
    anchor: [0, 0]

  initialize: (opts) =>
    @title = opts.title
    @lat   = opts.lat
    @lng   = opts.lng
    @map   = opts.map

    if opts.markerImage
      @markerImage = _.extend({}, @defaultMarkerImage, opts.markerImage)
      if opts.markerShadow
        @markerShadow = _.extend({}, @defaultMarkerShadow, opts.markerShadow)

  render: =>
    @infobox = new InfoBox
      content: HandlebarsTemplates['gmaps_infobox'](title: @title)
      disableAutoPan: true
      # disableAutoPan: false
      maxWidth: 100
      pixelOffset: new google.maps.Size(25, -37)
      zIndex: null
      # infoBoxClearance: new google.maps.Size(10, 10)
      isHidden: false
      enableEventPropagation: false

    opts =
      position: new google.maps.LatLng(@lat, @lng)
      map: @map.getGmap()
      title: @title

    if @markerImage
      opts.icon = new google.maps.MarkerImage(
        @markerImage.url,
        new google.maps.Size(@markerImage.size...),
        new google.maps.Point(@markerImage.origin...),
        new google.maps.Point(@markerImage.anchor...),
      )

      if @markerShadow
        opts.shadow = new google.maps.MarkerImage(
          @markerShadow.url,
          new google.maps.Size(@markerShadow.size...),
          new google.maps.Point(@markerShadow.origin...),
          new google.maps.Point(@markerShadow.anchor...),
        )

    @marker = new google.maps.Marker(opts)
    google.maps.event.addListener(@marker, 'mouseover', _.debounce(@showInfoBox))
    google.maps.event.addListener(@marker, 'mouseout', _.debounce(@hideInfoBox))

  close: =>
    google.maps.event.clearListeners(@marker, 'mouseover')
    google.maps.event.clearListeners(@marker, 'mouseout')
    @marker.setMap(null)
    @marker = null
    super()

  showInfoBox: (event) =>
    @infobox.open(@gmap, @marker)

  hideInfoBox: =>
    @infobox.close()
