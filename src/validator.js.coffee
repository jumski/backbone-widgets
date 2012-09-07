
Backbone.Widgets.Validator =

  conditional: (opts) ->
    (value, formValues) ->
      return unless opts.validateIf(value, formValues)

      error = null
      getValidator = Backbone.Form.helpers.getValidator

      _.every opts.validators, (validator) ->
        error = getValidator(validator)(value, formValues)
        !error

      error

