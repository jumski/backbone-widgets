class Backbone.Widgets.Form extends Backbone.Form
  events:
    'click button' : 'saveIfValid'

  initialize: (options = {button: {}}) =>
    super(options)
    @button = new Backbone.Widgets.AnimatedButton options.button

    if (@events)
      @events = _.defaults(@events, Backbone.Widgets.Form.prototype.events)
    @delegateEvents(@events)

  render: ->
    super()

    # render commit button
    $container = $('<div class="form-actions"></div>')
    $container.append @button.render().el
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
    @model.on 'sync', ->
      console.log 'asdf'
    unless @commit()
      @button.disable()
      @model.on 'error', @button.enable
      @model.save success: @button.enable
