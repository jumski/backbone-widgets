#= require gmaps_infobox

class Backbone.Widgets.MapMarker extends Backbone.View
  iconDefaults:
    origin: [0, 0]
    anchor: [0, 0]
  shadowDefaults:
    origin: [0, 0]
    anchor: [0, 0]
  infoBoxDefaults:
    disableAutoPan: true
    # works with above set to false - it is an auto pan margin
    # infoBoxOptsClearance: new google.maps.Size(10, 10)
    zIndex: null
    isHidden: false
    enableEventPropagation: false

  infoBoxPinned: false

  initialize: (opts) =>
    @title = opts.title
    @lat   = opts.lat
    @lng   = opts.lng
    @map   = opts.map

    if opts.icon
      @iconOpts = _.extend({}, @iconDefaults, opts.icon)
      if opts.shadow
        @shadowOpts = _.extend({}, @shadowDefaults, opts.shadow)

    if opts.infoBox
      @infoBoxOpts = _.extend({}, @infoBoxDefaults, opts.infoBox)

  render: =>
    markerOpts =
      position: new google.maps.LatLng(@lat, @lng)
      map: @map.getGmap()
      title: @title

    # initialize image/shadow
    if @iconOpts
      markerOpts.icon = new google.maps.MarkerImage(
        @iconOpts.url,
        new google.maps.Size(@iconOpts.size...),
        new google.maps.Point(@iconOpts.origin...),
        new google.maps.Point(@iconOpts.anchor...),
      )

      if @shadowOpts
        markerOpts.shadow = new google.maps.MarkerImage(
          @shadowOpts.url,
          new google.maps.Size(@shadowOpts.size...),
          new google.maps.Point(@shadowOpts.origin...),
          new google.maps.Point(@shadowOpts.anchor...),
        )

    # create marker object
    @marker = new google.maps.Marker(markerOpts)

    # initialize infoBox
    if @infoBoxOpts
      @infoBox = new InfoBox(@infoBoxOpts)
      google.maps.event.addListener(@marker, 'click', @toggleInfoBoxPinned)
      google.maps.event.addListener(@marker, 'mouseover', @onMouseOver)
      google.maps.event.addListener(@marker, 'mouseout', @onMouseOut)

  onMouseOver: =>
    return if @map.infoBoxPinned
    @showInfoBox()

  onMouseOut: =>
    return if @map.infoBoxPinned
    @hideInfoBox()

  toggleInfoBoxPinned: =>
    @map.infoBoxPinned = ! @map.infoBoxPinned
    console.log "pinned = #{@map.infoBoxPinned}"

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
