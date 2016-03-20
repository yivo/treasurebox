#  .js-form
#    form
#      .js-form-group
#        .js-form-label
#        .js-form-input
#        .js-form-error
#    .js-form-progress
#    .js-form-success
#    .js-form-failure
#
#    .js-form-controls
#      .js-form-action.js-form-submit
#    .js-form-success-controls
#    .js-form-failure-controls

$ ->
  $(document).on 'submit', 'form', (e) ->
    $form   = $(e.currentTarget)
    $widget = $form.parents('.js-form')
    return unless $widget[0]

    $button = $widget.find('.js-form-submit:first')
    return unless $button[0]

    e.preventDefault()
    submit($button)
    return

  $(document).on 'click', '.js-form .js-form-submit', (e) ->
    e.preventDefault()
    $button = $(e.currentTarget)
    submit($button)
    return

submit = ($button) ->
  $widget = $button.parents('.js-form')
  $form   = $widget.find('form')

  return if not $form[0] or $widget.data('form-progress') or
                            $widget.data('form-success') or
                            $widget.data('form-failure')

  $widget.data('form-progress', true)

  $errors   = $widget.find('.js-form-errors')
  $progress = $widget.find('.js-form-progress')
  $buttons  = $widget.find('.js-form-action')
  $controls = $widget.find('.js-form-controls')
  url       = $form.attr('action')

  originalText = $button.text()
  progressText = $button.data('progress-text')
  $button.text(progressText) if progressText
  textChanged = !!progressText and originalText != progressText
  $buttons.prop('disabled', true)

  data = {}
  for own k, v of ($button.data() or {})
    data[k.replace(/-/g, '_')] = v
  for {name, value} in $form.serializeArray()
    data[name] = value

  now     = -> Date.now?() or new Date().getTime()
  started = now()
  atLeast = (required, callback) ->
    current = now()
    passed  = current - started
    if passed < required
      setTimeout(callback, required - passed)
    else
      callback()

  reset = ->
    $widget.removeClass('success failure progress has-errors')
    $widget.find('.has-errors').removeClass('has-errors')
    $errors.empty()
    $widget.find('.js-form-error').remove()

  doneWith = (status) ->
    $widget.addClass(status)
    $block = $widget.find(".js-form-#{status}")
    fadeIn $block, ->
      $progress.hide().css(opacity: 0)
      $widget.data(formFailure: no, formSuccess: no, formProgress: no)
      $widget.data("form-#{status}", yes)
    $controls.hide()
    fadeIn $widget.find(".js-form-#{status}-controls")
    $.scrollTo?($block, pad: 65)

  arrayErrors = (errors) ->
    for msg in errors.slice(0, 2)
      try $errors.append('<div class="form-error js-form-error">' + msg + '</div>')
    return

  objectErrors = (errors) ->
    for own name, deepErrors of errors
      $input = try $widget.find('[name="' + name + '"]')
      continue unless $input?[0]

      $group = $input.parents('.js-form-group')
      continue unless $group[0]

      $err = $group.find('.js-form-error')
      $err = $('<div class="form-error js-form-error"/>') unless $err[0]
      $err.text(deepErrors[0])
      $group.append($err)
      $group.addClass('has-errors')
    return

  promise = $.post(url, data, $.noop, 'json')
  $widget.addClass('progress')
  fadeIn($progress)

  promise.done (res) ->
    atLeast 500, ->
      reset()
      doneWith('success')

  promise.fail (res) ->
    atLeast 500, ->
      reset()
      if errors = res?.responseJSON?.errors
        if $.isArray(errors)
          arrayErrors(errors)
        else if typeof errors is 'object'
          objectErrors(errors)

        $widget.addClass('has-errors')
        fadeOut $progress, -> $widget.data('form-progress', false)
        $.scrollTo?($errors, pad: 65)

      else doneWith('failure')

  promise.always ->
    atLeast 500, ->
      $button.text(originalText) if textChanged
      $buttons.prop('disabled', false)

fadeIn = ($el, callback) ->
  $el.show()
  $el[0]?.offsetWidth if $.support.transition
  $el.css(opacity: 1)
  done = ->
    callback?()
  if $.support.transition
    $el.one('transitionEnd', done).emulateTransitionEnd(300)
  else done()

fadeOut = ($el, callback) ->
  $el.css(opacity: 0)
  done = ->
    $el.hide()
    callback?()
  if $.support.transition
    $el.one('transitionEnd', done).emulateTransitionEnd(300)
  else done()