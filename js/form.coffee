# TODO Refactor
$(document).on 'page:change', ->
  $('.js-form .js-submit-action').click (e) ->
    e.preventDefault()

    $button = $(e.currentTarget)
    $widget = $button.parents('.js-form')
    $form   = $widget.find('form')

    return if $widget.data('submitting') or $widget.data('submitted')

    $errors   = $widget.find('.js-form-errors')
    $progress = $widget.find('.js-form-progress')
    $buttons  = $widget.find('.js-button')
    data      = {}
    url       = $form.attr('action')

    $widget.data('submitting', true)
    originalText = $button.text()
    progressText = $button.data('progress-text')
    $button.text(progressText) if progressText
    textChanged = !!progressText

    $buttons.prop('disabled', true)

    for {name, value} in $form.serializeArray()
      data[name] = value

    extraData = $button.data()
    if extraData
      for own k, v of extraData
        data[k.snakeCase()] = v

    promise = $.post(url, data, $.noop, 'json')

    now = ->
      Date.now?() or new Date().getTime()

    $progress.fadeIn(300)

    started = now()

    promise.done (res) ->
      atLeast 500, ->
        $widget.data('submitted', true)
        $widget.removeClass('has-errors')
        $widget.find('.has-errors').removeClass('has-errors')
        $errors.empty()
        $widget.find('.js-error').remove()
        $widget.addClass('success')
        $success = $widget.find('.js-form-success')
        $success.fadeIn(300)
        $.scrollTo?($success, pad: 65)

    promise.fail (res) ->
      if errors = res?.responseJSON?.errors
        $errors.empty()
        $widget.find('.js-error').remove()

        if $.isArray(errors)
          for msg in res.responseJSON.errors.slice(0, 2)
            $errors.append $("<label>#{msg}</label>")

        else if typeof errors is 'object'
          for own name, msg of errors
            $input = try $widget.find('[name="' + name + '"]')
            continue unless $input?[0]

            $group = $input.parents('.js-input-group')
            continue unless $group[0]

            $label = $input.find('label')
            $label = $('<label/>') unless $label[0]
            $label.addClass('js-error')
            $label.text(msg)
            $group.append($label)

        $widget.addClass('has-error')
        $.scrollTo?($errors, pad: 65)
        $progress.fadeOut(300)

      else
        atLeast 500, ->
          $widget.data('submitted', true)
          $widget.removeClass('has-errors')
          $widget.addClass('failure')
          $errors.empty()
          $failure = $widget.find('.js-form-failure')
          $failure.fadeIn(300)
          $.scrollTo?($failure, pad: 65)

    atLeast = (ms, callback) ->
      current = now()
      passed  = current - started

      if passed < ms
        setTimeout(callback, ms - passed)
      else
        callback()

    promise.always ->
      $widget.data('submitting', false)
      $button.text(originalText) if textChanged
      $widget.find('.js-button').prop('disabled', false)