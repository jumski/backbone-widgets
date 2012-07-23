#= require jquery.fileupload

class Backbone.Widgets.FileUploadInput extends Backbone.View
  tagName: 'input'
  className: 'file-upload btn'
  attributes:
    multiple: 'multiple'
    type: 'file'

  render: =>
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
    @$el.fileupload opts

    # proxy events
    @$el.on 'fileuploadadd', (event, data) =>
      @trigger 'add', event, data

    @
