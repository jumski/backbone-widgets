#= require jquery-ui

class Backbone.Widgets.Datepicker extends Backbone.Form.editors.Base
  tagName: 'input'
  attributes:
    type: "text"

  initialize: (options) =>
    super(options)

    @$el.datepicker
      dateFormat: "yy-mm-dd"
      minDate: new Date
      maxDate: "+1m"
      monthNames: I18n.t('date.month_names')
      dayNamesMin: I18n.t('date.abbr_day_names')

    @setValue(@value)

  getValue: =>
    @$el.val()

  setValue: (value) =>
    @$el.val(value)

  render: =>
    @
