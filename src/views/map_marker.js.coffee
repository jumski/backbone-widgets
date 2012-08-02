#= require gmaps_infobox

class Backbone.Widgets.MapMarker extends Backbone.View
  timeout: null

  initialize: (opts) =>
    @title = opts.title
    @lat   = opts.lat
    @lng   = opts.lng
    @map   = opts.map

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
      icon: "https://developers.google.com/maps/documentation/javascript/examples/images/beachflag.png"
      title: @title
      mouseover: @showinfoBox
      mouseout: @hideinfoBox

  showinfoBox: (event) =>
    clearTimeout(@timeout)
    @infobox.open(@map.gmap.map, @marker)

  hideinfoBox: =>
    clearTimeout(@timeout) if @timeout
    @timeout = setTimeout((=> @infobox.close()), 200)
