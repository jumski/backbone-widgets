class Backbone.Widgets.Form extends Backbone.Form
  events:
    'click button' : 'saveIfValid'

  initialize: (options = {button: {}}) =>
    # hack !
    if @schema
      options.schema = @schema

    super(options)
    @button = new Backbone.Widgets.AnimatedButton options.button

    if @events
      @events = _.defaults(@events, Backbone.Widgets.Form.prototype.events)
    @delegateEvents(@events)

  render: ->
    super()

    # render commit button
    $container = $('<div class="form-actions"></div>')
    $container.append @button.render().el
    @$el.find('fieldset').append $container
    @

  saveIfValid: (event) =>
    event.preventDefault()
    event.stopPropagation()

    # pass attributes to model and validate,
    # save unless we've got errors
    unless @commit()
      @button.disable()
      @model.on 'error', @button.enable
      @model.save success: @button.enable

  ########################
  # Validation shortcuts #
  ########################
  @validateLength: (min, max) ->
    type: 'regexp'
    regexp: new RegExp("^.{#{min},#{max}}$")
    message: I18n.t('validaton_errors.length_not_matched', {min: min, max: max})

  @validateNumericality: ->
    type: 'regexp'
    regexp: /^\d+([,\.]\d{0,2})?$/
    message: I18n.t('validaton_errors.provide_valid_number')

