class Backbone.Widgets.Form extends Backbone.Form
  events:
    'click button' : 'saveIfValid'

  initialize: (options = {button: {}}) =>
    # hack !
    if @schema
      if @schema.call
        options.schema = @schema()
      else
        options.schema = @schema

    if @template
      options.template = @template

    super(options)
    @button = new Backbone.Widgets.AnimatedButton options.button

    if @events
      @events = _.defaults(@events, Backbone.Widgets.Form.prototype.events)
    @delegateEvents(@events)

  render: ->
    super()

    @appendSubmitButton()
    @

  appendSubmitButton: =>
    $container = $('<div class="form-actions"></div>')
    $container.append @button.render().el
    @$el.find('fieldset').append $container

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
    message: I18n.t('validation_errors.length_not_matched', {min: min, max: max})

  @validateNumericality: ->
    type: 'regexp'
    regexp: /^\d+([,\.]\d{0,2})?$/
    message: I18n.t('validation_errors.provide_valid_number')

  @validateGreaterThan: (number) ->
    (value, formValues) ->
      return if parseFloat(value) > parseFloat(number)

      type: 'greaterThan'
      message: I18n.t('validation_errors.expects_greater_than', number: number)

  @validateLessThan: (number) ->
    (value, formValues) ->
      return if parseFloat(value) < parseFloat(number)

      type: 'lessThan'
      message: I18n.t('validation_errors.expects_less_than', number: number)

  @validateGreaterThanOrEqualTo: (number) ->
    (value, formValues) ->
      return if parseFloat(value) >= parseFloat(number)

      type: 'greaterThanOrEqualTo'
      message: I18n.t('validation_errors.expects_greater_than_or_equal_to', number: number)

  @validateLessThanOrEqualTo: (number) ->
    (value, formValues) ->
      return if parseFloat(value) <= parseFloat(number)

      type: 'lessThanOrEqualTo'
      message: I18n.t('validation_errors.expects_less_than_or_equal_to', number: number)

  @validateUniquenessOfEmail: ->
    (email, formValues) ->
      console.log formValues
      response = $.ajax
        url: '/validators/email.json'
        data:
          email: email
        async: false

      unless response.status == 200
        type: 'uniqueEmail'
        message: I18n.t('errors.messages.email_has_been_taken')

  @validateMultiple: (validators...) ->



