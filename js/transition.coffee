# Taken from bootstrap: https://github.com/twbs/bootstrap/blob/master/js

transitionEnd = ->
  el = document.createElement('div')

  transEndEventNames =
    WebkitTransition: 'webkitTransitionEnd',
    MozTransition   : 'transitionend',
    OTransition     : 'oTransitionEnd otransitionend',
    transition      : 'transitionend'

  for name of transEndEventNames
    return end: transEndEventNames[name] if el.style[name]?

  false

# http://blog.alexmaccaw.com/css-transitions
$.fn.emulateTransitionEnd = (duration) ->
  called = no
  $el    = this
  $el.one 'transitionEnd', -> called = yes

  callback = ->
    $el.trigger($.support.transition.end) unless called
    return

  setTimeout(callback, duration)
  this

$ ->
  $.support.transition = transitionEnd()

  return unless $.support.transition

  $.event.special.transitionEnd =
    bindType:     $.support.transition.end,
    delegateType: $.support.transition.end,
    handle:       (e) -> e.handleObj.handler.apply(this, arguments) if $(e.target).is(this)