#= require_tree .

if 'ontouchstart' not in window then new window.oof.Bubbles
  style: ->
    {
      strokeStyle: 'yellow'
      fillStyle: 'yellow'
      strokeWidth: 6
    }
  canvas_unsupported: 'Sorry, your browser doesn’t support the Canvas API for drawing fun things.'
  splatter_threshold: 2
  max_splats: 1
  canvas_size: Math.max window.innerWidth, window.oof.fn.document_height()
  canvas_frame: $('.canvas-frame')
