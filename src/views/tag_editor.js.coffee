class Backbone.Widgets.TagEditor extends Backbone.Form.editors.Base
  tags: []

  tagName: 'div'
  defaultValue: ''

  events:
    'click .tag'     : 'onTagClick'
    'keypress input' : 'onInputKeypress'
    'keydown input'  : 'onInputKeydown'
    'blur input'     : 'onInputBlur'

  initialize: (options) =>
    super(options)

    if options.schema.collection?
      @collection = options.schema.collection

    @setValue(@value)

    @$tagsList = $('<ul> </ul>').addClass('tageditor').hide()
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

    # render SuggestionsForInput
    @$suggestions = new Backbone.Widgets.SuggestionsForInput
      el: @$input, collection: @collection
    @$suggestions.on 'select', (event, item) =>
      event.preventDefault()
      event.stopPropagation()
      @$input.val('').focus()
      @addTag item.value

    @$suggestions.render()

    @$el.append @$tagsList
    @$el.append @$input
    @

  # event handlers
  onTagClick: (event) =>
    $tag = $(event.target)
    @removeTag($tag.text())

  onInputBlur: (event) =>
    return if @$suggestions.isSuggesting()
    unless @$input.val() == ''
      @addTag @sanitizedInputValue()

  onInputKeypress: (event) =>
    if event.charCode == 44 || event.charCode == 13 # , or <CR>
      @addTag @sanitizedInputValue()
      event.preventDefault()

  onInputKeydown: (event) =>
    if @$input.val() == '' && event.keyCode == 8 # backspace
      @removeLastTag()

  # backbone form interface
  getValue: =>
    @filteredTags()

  setValue: (value) =>
    @tags = _.map(value, jQuery.trim)

  # instance methods
  renderTags: =>
    _.map(@filteredTags(), @renderTag).join(' ')

  filteredTags: =>
    _.reject @tags, (tag) -> tag == ''

  renderTag: (tag) =>
    "<li class='tag'>#{tag}</li>"

  removeTag: (tag) =>
    @tags = _.without(@tags, tag)

    @render()
    @$input.focus()

  removeLastTag: (event) =>
    @removeTag _.last(@tags)

  addTag: (value) =>
    if value && !@hasTag(value)
      @tags.push value
      @render()
      @$input.val('').focus()

  sanitizedInputValue: =>
    @sanitizeValue @$input.val()

  hasTag: (value) =>
    jQuery.inArray(value, @tags) >= 0

  sanitizeValue: (value) =>
    value.toLowerCase().replace(/[^a-z0-9 ]/g, '')
