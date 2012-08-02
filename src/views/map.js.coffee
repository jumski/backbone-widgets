#= require gmaps
#= require gmaps_infobox

class Backbone.Widgets.Map extends Backbone.View
  initialize: (opts) =>
    @lat = opts.lat
    @lng = opts.lng
    @el = opts.el
    @markers = opts.markers

  render: =>
    if $('#map').length
      @map = new GMaps
        div: @$el.attr('id')
        lat: @lat
        lng: @lng

      # render all markers
      # _(@markers).each (marker) => marker.render()

      _(@markers).each (marker) =>
        @infobox = new InfoBox
          content: HandlebarsTemplates['gmaps_home'](title: marker.title)
          disableAutoPan: false
          maxWidth: 100
          pixelOffset: new google.maps.Size(25, -37)
          zIndex: null
          infoBoxClearance: new google.maps.Size(1, 1)
          isHidden: false
          enableEventPropagation: false

        @timeout = null

        @showinfoBox = (event) =>
          clearTimeout(@timeout)
          @infobox.open(@map.map, @marker)
        @hideinfoBox = =>
          clearTimeout(@timeout) if @timeout
          @timeout = setTimeout((=> @infobox.close()), 300)

        @marker = @map.addMarker
          lat: marker.lat
          lng: marker.lng
          icon: "https://developers.google.com/maps/documentation/javascript/examples/images/beachflag.png"
          title: 'me haxy!'
          mouseover: @showinfoBox
          mouseout: @hideinfoBox
