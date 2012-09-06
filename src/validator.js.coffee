
Backbone.Widgets.Validator =

  multiple: (opts) ->
    (value, formValues) =>
      return unless opts.validateIf()

      error = null

      _.every opts.validators, (validator) ->
        error = getValidator(validator)(value, formValues)
        !error

      error

