class Backbone.Widgets.Tageditor extends Backbone.Form.editors.Base
  tags: []

  tagName: 'div'
  defaultValue: ''

  events:
    'click .tag' : 'clickTag'
    'keypress'   : 'interpretKeypress'
    'keydown'    : 'interpretKeydown'

  initialize: (options) =>
    super(options)

    @setValue(@value)

    @$tagsList = $('<ul> </ul>').addClass('tags_list').hide()
    @$input = $('<input type="text" />').attr('name', @getName())
    @id = @$el.attr('id')
    @name = @$el.attr('name')
    @$el.removeAttr('name').removeAttr('id')

  render: =>
    @$tagsList.attr('id', @id).attr('name', @name).show()
    @$tagsList.html @renderTags()

    # element must be rendered to report width
    width = @$tagsList.width()
    if width == 0
      # so we initially render it only to get it
      $(document).find('body').append @$tagsList.css('display', 'inline')
      width = @$tagsList.width()

    @$input.css 'padding-left', width + 7

    @$el.append @$tagsList
    @$el.append @$input
    @

  getValue: =>
    @tags.join(', ')

  setValue: (value) =>
    @tags = _.map(value.split(','), jQuery.trim)

  renderTags: =>
    (_.map @tags, @renderTag).join(' ')

  renderTag: (tag) =>
    "<li class='tag'>#{tag}</li>"

  clickTag: (event) =>
    $tag = $(event.target)
    @removeTag($tag.text())

  removeTag: (tag) =>
    @tags = _.without(@tags, tag)

    @render()
    @$input.focus()

  removeLastTag: (event) =>
    @removeTag _.last(@tags)

  addTag: =>
    value = @sanitizeValue @$input.val()
    if value && !@hasTag(value)
      @tags.push value
      @render()
      @$input.val('').focus()

  hasTag: (value) =>
    jQuery.inArray(value, @tags) >= 0

  sanitizeValue: (value) =>
    value.toLowerCase().replace(/[^a-z0-9 ]/g, '')

  interpretKeypress: (event) =>
    if event.charCode == 44 || event.charCode == 13 # , or <CR>
      @addTag()
      event.preventDefault()

  interpretKeydown: (event) =>
    if @$input.val() == '' && event.keyCode == 8 # backspace
      @removeLastTag()

