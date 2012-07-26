#= require jquery.fileupload

class Backbone.Widgets.FileUploadInput extends Backbone.Form.editors.Base
  tagName: 'div'
  className: 'file-upload'

  initialize: (options) =>
    super(options)

    @setValue(@value)

  # backbone form interface
  getValue: =>
    'hax'

  setValue: (value) =>
    console.log value

  render: =>
    @$el.html HandlebarsTemplates['file_upload']()

    type = if @model.id
             'put'
           else
             'post'
    paramName = 'picture[asset]'
    opts =
      type: type
      url: @model.url()
      dataType: 'json'
      paramName: paramName
      limitMultiFileUploads: 1
      done: (event, data) =>
        @trigger 'done', event, data

    # initialize
    @$el.find('input').fileupload(opts)
        .on 'fileuploadadd', (event, data) =>
          @trigger 'add', event, data

    @
