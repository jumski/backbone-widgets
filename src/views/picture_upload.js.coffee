#= require jquery.fileupload

class Backbone.Widgets.PictureUpload extends Backbone.Form.editors.Base
  tagName: 'div'
  className: 'picture-upload'

  initialize: (options) =>
    super(options)

    @model = options.schema.model
    @model.on 'change', @updatePicture

    @setValue(@value)

  # backbone form interface
  getValue: =>
    @model.get('url')

  setValue: (value) =>
    @model.set('url', value)

  updatePicture: =>
    if url = @model.get('thumb_url')
      @$el.find('img').attr('src', url).show()
    else
      @$el.find('img').attr('src', '').hide()

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
        @trigger 'done', event, data

    # initialize
    @$el.find('input').fileupload(opts)
        .on 'fileuploadadd', (event, data) =>
          # @model.set(data.result)
          # @$el.find('img').attr('src', data.result.thumb_url)

    @
