#= require gmaps_infobox

class Backbone.Widgets.MapMarker extends Backbone.View
  initialize: (opts) =>
    @title = opts.title
    @lat   = opts.lat
    @lng   = opts.lng
    @map   = opts.map
    @color = opts.color

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

    icon = new google.maps.MarkerImage(
      "/assets/marker-#{@color}.png",
      new google.maps.Size(28, 27),
      new google.maps.Point(0, 0),
      new google.maps.Point(14, 27),
    )
    shadow = new google.maps.MarkerImage(
      "/assets/marker-shadow.png",
      new google.maps.Size(26, 28),
      new google.maps.Point(0, 0),
      new google.maps.Point(8, 28),
    )

    @marker = new google.maps.Marker
      position: new google.maps.LatLng(@lat, @lng)
      map: @map.getGmap()
      title: @title
      icon: icon
      shadow: shadow
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
