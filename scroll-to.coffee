$.scrollTo = (target, options = {}) ->
  $el = $(target)

  return $el unless $el[0]

  if options.visible == no or $el.visible?() == false and $el.is(':visible')
    speed = options.speed ? 500
    top   = options.top ? $el.offset().top
    top   -= options.pad if options.pad

    $root = $('html, body')
    $root.animate(scrollTop: top, speed)
  $el

callback = ->
  if match = location.search?.match?(/scroll=([^&]+)/)
    try history.replaceState({}, document.title, location.pathname)

    selectors = decodeURIComponent(match[1]).split(',')
    index     = -1
    next = ->
      $.scrollTo($(selectors[++index]), visible: false)
      if selectors[index + 1]
        setTimeout next, 200
    setTimeout(next, 200)

  $('.js-scroll-trigger').click (e) ->
    e.preventDefault()
    if selector = $(this).data('scroll')
      try $block = $(selector)
      $.scrollTo($block) if $block
    return

if Turbolinks?
  $(document).on('page:change', callback)
else
  $(document).on('ready pjax:end', callback)