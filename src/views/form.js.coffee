class Backbone.Widgets.Form extends Backbone.Form
  baseEvents:
    'click button' : 'saveIfValid'

  initialize: (options = {button: {}}) =>
    super(options)
    @$button = new Backbone.Widgets.AnimatedButton options.button

    # ugly custom hack for events hash inheritance
    # this is not solved properly in backbone for now,
    # only partial solutions exists,
    # @see https://github.com/documentcloud/backbone/issues/244
    # this way we can define "events" hash in sublasses as normal,
    # and it will gets merged with our base class events
    # there is a limitation tho - works only for one level of inheritance
    @inheritedEvents = @events
    @events = _(@baseEvents).extend(@inheritedEvents)
    @delegateEvents()

  render: ->
    super()

    # render commit button
    $container = $('<div class="form-actions"></div>')
    $container.append @$button.render().el
    @$el.find('fieldset').append $container

    # HACK!
    # copy helps as placeholders
    @$el.find('.help-block').each (index, element) ->
      help = $(element).text()
      $field = $(element).siblings('.input-xlarge').find('input, textarea')
      $field.attr('placeholder', help)

    @

  saveIfValid: (event) =>
    event.preventDefault()
    event.stopPropagation()

    # pass attributes to model and validate,
    # save unless we've got errors
    unless @commit()
      @$button.disable()
      @model.on 'error', @$button.enable
      @model.save success: @$button.enable
