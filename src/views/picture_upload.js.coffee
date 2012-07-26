#= require jquery.fileupload

class Backbone.Widgets.PictureUpload extends Backbone.Form.editors.Base
  tagName: 'div'
  className: 'picture-upload'

  initialize: (options) =>
    super(options)

    @model = options.schema.model
    @model.on 'change:thumb_url', @updatePicture

    @setValue(@value)

  # backbone form interface
  getValue: =>
    @model.get('id')

  setValue: (value) =>
    @updatePicture()
    @model.set('id', value)
    @model.fetch() if value

  updatePicture: =>
    if url = @model.get('thumb_url')
      @$el.find('img').attr('src', url)
    else
      @$el.find('img').attr('src', '')

  render: =>
    @$el.html HandlebarsTemplates['picture_upload'](@model.toJSON())

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
        @model.set(data.result)

    # initialize
    @$el.find('input').fileupload(opts)

    @
