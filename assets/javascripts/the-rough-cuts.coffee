# The Rough Cuts -Interactions
# =============================

#= require jquery-1.9.1.min
#= require underscore-min
#= require backbone-min

$body   = $ 'body'
$window = $ window

class Screen extends Backbone.View
  el: $ 'body'

  # Layout specific variables
  layout:

    # Sections are always a 3rd of the screen size
    sectionSize: 1/3

    # Get the gutter size from CSS
    gutter: parseInt $body.css 'padding-left'

  # Sets the size of each section in a cascade-like effect
  setSectionsSize: ->
    for section in $body.find('>section')
      $section = $ section
      $section.width @recommendedSectionSize()

  # Find out a good size for each section in the screen
  recommendedSectionSize: ->
    size = (window.innerWidth * @layout.sectionSize)
    size = size - @layout.gutter*1.5
    size

$ ->
  App =
    Screen: new Screen

  debouncedResize = _.debounce ->
    App.Screen.setSectionsSize()
  , 300

  $window.on 'resize', -> debouncedResize()
  $window.trigger 'resize'

