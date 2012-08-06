#= require gmaps_infobox

class Backbone.Widgets.MapMarker extends Backbone.View
  timeout: null

  initialize: (opts) =>
    @title = opts.title
    @lat   = opts.lat
    @lng   = opts.lng
    @map   = opts.map
    @color = opts.color

  render: =>
    @infobox = new InfoBox
      content: HandlebarsTemplates['gmaps_infobox'](title: @title)
      disableAutoPan: false
      maxWidth: 100
      pixelOffset: new google.maps.Size(25, -37)
      zIndex: null
      infoBoxClearance: new google.maps.Size(1, 1)
      isHidden: false
      enableEventPropagation: false

    @marker = @map.gmap.addMarker
      lat: @lat
      lng: @lng
      icon: "/assets/marker-#{@color}.png"
      title: @title
      mouseover: @showInfoBox
      mouseout: @hideInfoBox

  showInfoBox: (event) =>
    clearTimeout(@timeout)
    @infobox.open(@map.gmap.map, @marker)

  hideInfoBox: =>
    clearTimeout(@timeout) if @timeout
    @timeout = setTimeout((=> @infobox.close()), 200)
