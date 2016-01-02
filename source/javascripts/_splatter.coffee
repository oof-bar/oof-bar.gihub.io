window.oof.Bubbles = class Bubbles
  constructor: (options) ->
    @options = $.extend
      style: ->
        'black'
      splatter_threshold: 10
      canvas_size: window.innerWidth * 2
      canvas_frame: $('.canvas-frame')
    , options

    @canvas = $('<canvas />').attr
      width: @options.canvas_size * @scale()
      height: @options.canvas_size * @scale()
    @canvas.appendTo @options.canvas_frame
    @canvas.width @options.canvas_size

    @context = @canvas[0].getContext('2d')
    @listen()

  listen: ->
    $(document).on 'mousemove', (e) =>
      @track e
      @draw()

    $(document).on 'click', (e) =>
      @clear()

  scale: ->
    if window.hasOwnProperty('devicePixelRatio') then window.devicePixelRatio else 1

  delta: (start = @previous(), end = @current) ->
    Math.sqrt(Math.pow((start.y - end.y), 2) + Math.pow((start.x - end.x), 2))

  time_elapsed: ->
    @current.time - @previous().time

  velocity: ->
    # Pixels per milisecond
    @delta(@current, @previous()) / @time_elapsed()

  trajectory: ->
    {
      x: ( @current.x + (@current.x - @previous().x) * 2 ) * @scale()
      y: ( @current.y + (@current.y - @previous().y) * 2 ) * @scale()
    }

  previous: ->
    @last_event or
      x: window.innerWidth / 2
      y: window.innerHeight / 2
      time: new Date()

  draw: (e) ->
    @splatter() if @velocity() > @options.splatter_threshold
  
  track: (e) ->
    now =
      x: e.pageX
      y: e.pageY
      time: e.timeStamp

    unless @last_event?
      @last_event = @current = now
    else
      @last_event = @current
      @current = now

  stylize: ->
    @context.strokeStyle = @options.style().strokeStyle
    @context.fillStyle = @options.style().fillStyle
    @context.lineWidth = @options.style().strokeWidth

  splatter: ->
    if Math.random() > 0.5
      location = @trajectory()
      size = 10 + Math.min Math.pow(@velocity(), 1.2), 150
      @spot location, size

  spot: (location, radius) ->
    @stylize()
    @context.beginPath()
    @context.arc location.x, location.y, radius * @scale(), 0, 2 * Math.PI
    @context.fill()
    @context.stroke()

  clear: ->
    @context.clearRect 0, 0, @canvas.attr('width'), @canvas.attr('height')

  blot: (e) ->
    for drop in [0..(Math.random() * @options.max_splats)]
      @spot
        x: e.pageX.random_within 50
        y: e.pageY.random_within 50
      , Math.sqrt(Math.random() * 1000) 

  change_color: (new_color) ->
    @context.strokeStyle = new_color
    @context.fillStyle = new_color
