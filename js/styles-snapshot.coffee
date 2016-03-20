{getComputedStyle} = window ? this

$.fn.snapshotStyles = (styles) ->
  if getComputedStyle?
    for el in this
      for style, i in styles
        el.style[style] = getComputedStyle(el)[style]
  this

$.fn.releaseSnapshot = (styles) ->
  for el in this
    el.offsetHeight
    for style, i in styles
      el.style[style] = ''
  this