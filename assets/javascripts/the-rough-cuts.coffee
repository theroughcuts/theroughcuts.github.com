# The Rough Cuts -Interactions
# =============================

#= require jquery-1.9.1.min
#= require underscore-min
#= require backbone-min

$window = $ window
$html   = $ 'html'
$body   = $ 'body'

class Screen extends Backbone.View
  el     : $ 'body'
  events :
    'click section'  : 'clickSection'
    'click .go-home' : 'clickGoBack'

  # Layout specific variables
  layout:

    # Section proportion is always a 3rd of the screen size
    sectionProportion: 1/3

    # Get the gutter size from CSS
    gutter: parseInt $body.css 'padding-left'

    # Narrow resolution breakpoint
    narrowBreak: 800

  # Constructs the layout
  setLayout: ->
    if window.innerWidth < @layout.narrowBreak
      $html.addClass 'narrow'
    else
      $html.removeClass 'narrow'
    @hideUrlBar()
    @setSectionsSize()

  # True/false if it's smaller than the narrow break
  isNarrow: ->
    $html.is '.narrow'

  # What happens when you click a section
  clickSection: (event) ->
    $section = $(event.target).closest 'section:not(.content)'
    App.Router.navigate $section.attr('class'), true

  # The "Go back" link on each page when active
  clickGoBack: (event) ->
    event.preventDefault()
    history.back()

  # Sets the size of each section in a cascade-like effect
  setSectionsSize: ->
    for section in $body.find('>section')
      $section = $ section
      $section.css @recommendedSectionSize()

  # Find out a good width for each section in the screen
  recommendedSectionSize: ->
    if @isNarrow()
      height = window.innerHeight * @layout.sectionProportion
      height = height - @layout.gutter*1.5
      width: '100%', height: height
    else
      width = window.innerWidth * @layout.sectionProportion
      width = width - @layout.gutter*1.5
      width: width, height: '100%'

  # Activates (expands) a section. Passing 'none' to it deactivates
  # all sections
  activateSection: (className = 'none') ->
    $sections = @$el.find '>section'
    $sections.scrollTop(0)
    classes = _.map $sections, (section) -> $(section).attr 'class'
    @$el.removeClass classes.join ' '
    @$el.addClass className if className isnt 'none'

  # Hides the URL bar in some mobile devices
  hideUrlBar: ->
    window.scrollTo 0,0

class Router extends Backbone.Router
  routes:
    ''        : 'home'
    'what-is' : 'whatIs'
    'talks'   : 'talks'
    'contact' : 'contact'

  home: ->
    App.Screen.activateSection 'none'

  whatIs: ->
    App.Screen.activateSection 'what-is'

  talks: ->
    App.Screen.activateSection 'talks'

  contact: ->
    App.Screen.activateSection 'contact'

$ ->
  window.App =
    Screen: new Screen
    Router: new Router

  debouncedSetLayout = _.debounce ->
    App.Screen.setLayout()
  , 300

  $window.on 'resize', -> debouncedSetLayout()
  $window.trigger 'resize'

  Backbone.history.start pushState: true
