Backbone.Ultimate ||= {}

class Backbone.Ultimate.View extends Backbone.View

  viewOptions: []
  loadingState: null
  loadingWidthMethodName: "innerWidth"
  loadingHeightMethodName: "innerHeight"
  loadingStateClass: "loading"
  loadingOverlayClass: "loading-overlay"

  constructor: ->
    super


  # Overload parent method Backbone.View.setElement() as hook for findNodes().
  setElement: (element, delegate) ->
    super
    @findNodes()
    @

  findNodes: (jRoot = @$el, nodes = @nodes) ->
    jNodes = {}
    nodes = nodes()  if _.isFunction(nodes)
    if _.isObject(nodes)
      for nodeName, selector of nodes
        _isObject = _.isObject(selector)
        if _isObject
          nestedNodes = selector
          selector = _delete(nestedNodes, "selector")
        jNodes[nodeName] = @[nodeName] = jRoot.find(selector)
        if _isObject
          _.extend jNodes, @findNodes(jNodes[nodeName], nestedNodes)
    jNodes


  # Overload parent method Backbone.View._configure() as hook for reflectOptions().
  _configure: (options) ->
    super
    @reflectOptions()

  reflectOptions: (viewOptions = @viewOptions, options = @options) ->
    @[attr] = options[attr]  for attr in viewOptions  when options[attr]



  # Overloadable getter for jQuery-container that will be blocked.
  getJLoadingContainer: -> @$el

  loading: (state, text = "", circle = true) ->
    jLoadingContainer = @getJLoadingContainer()
    if jLoadingContainer and jLoadingContainer.length
      jLoadingContainer.removeClass @loadingStateClass
      jLoadingContainer.children(".#{@loadingOverlayClass}").remove()
      if @loadingState = state
        jLoadingContainer.addClass @loadingStateClass
        width = jLoadingContainer[@loadingWidthMethodName]()
        height = jLoadingContainer[@loadingHeightMethodName]()
        text = "<span class=\"text\">#{text}</span>"  if text
        circle = "<span class=\"circle\"></span>"  if circle
        style = "width: #{width}px; height: #{height}px; line-height: #{height}px;"
        jLoadingContainer.append "<div class=\"#{@loadingOverlayClass}\" style=\"#{style}\">#{circle}#{text}</div>"



  # Improve templating.
  jst: (name, context = @) ->
    JST["backbone/templates/#{name}"] context
