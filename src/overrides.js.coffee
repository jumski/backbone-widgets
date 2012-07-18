
Backbone.View.prototype.close = ->
  if @$el
    @$el.remove()
  @off()
