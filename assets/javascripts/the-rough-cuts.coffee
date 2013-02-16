# The Rough Cuts -Interactions
# =============================

#= require jquery-1.9.1.min
#= require underscore-min
#= require backbone-min

$body   = $ 'body'
$window = $ window

class Screen extends Backbone.View
  el     : $ 'body'
  events :
    'click section' : 'clickSection'

  # Layout specific variables
  layout:

    # Sections are always a 3rd of the screen size
    sectionWidth: 1/3

    # Get the gutter size from CSS
    gutter: parseInt $body.css 'padding-left'

  # What happens when you click a section
  clickSection: (event) ->
    $section = $(event.target).closest 'section:not(.content)'
    App.Router.navigate $section.attr('class'), true

  # Sets the size of each section in a cascade-like effect
  setSectionsWidth: ->
    for section in $body.find('>section')
      $section = $ section
      $section.width @recommendedSectionWidth()

  # Find out a good width for each section in the screen
  recommendedSectionWidth: ->
    width = (window.innerWidth * @layout.sectionWidth)
    width = width - @layout.gutter*1.5
    width

class Router extends Backbone.Router
  routes:
    ''        : 'home'
    'what-is' : 'whatIs'
    'talks'   : 'talks'
    'contact' : 'contact'

  home: ->
    $body.removeClass()

  whatIs: ->
    $body.removeClass().addClass 'what-is'

  talks: ->
    $body.removeClass().addClass 'talks'

  contact: ->
    $body.removeClass().addClass 'contact'

$ ->
  window.App =
    Screen: new Screen
    Router: new Router

  debouncedResize = _.debounce ->
    App.Screen.setSectionsWidth()
  , 300

  $window.on 'resize', -> debouncedResize()
  $window.trigger 'resize'

  Backbone.history.start pushState: true
