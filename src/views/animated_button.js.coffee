class Backbone.Widgets.AnimatedButton extends Backbone.View
  tagName: 'button'
  className: 'btn btn-primary btn-large'
  disabledClasses: 'disabled loading'
  label: 'Save'
  loadingLabel: 'Please wait...'

  initialize: (opts = {}) =>
    if opts.label
      @label = opts.label

    if opts.loadingLabel
      @loadingLabel = opts.loadingLabel

  render: =>
    @$el.html @renderHtml(true)
    @

  enable: =>
    @$el.removeClass(@disabledClasses)
        .removeAttr('disabled')
        .html(@renderHtml(true))


  disable: =>
    @$el.addClass(@disabledClasses)
        .attr('disabled', true)
        .html(@renderHtml(false))

  renderHtml: (enabled) =>
    label = if enabled
              @label
            else
              @loadingLabel

    "<i class='icon-white'></i>#{label}"
