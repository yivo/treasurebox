$.fn.transform = (transformation, x, y) ->
  switch arguments.length
    when 2
      value = if $.isNumeric(x)
        "#{transformation}(#{x}px)"
      else if x
        "#{transformation}(#{x})"
      else
        ''
    when 3
      value = "#{transformation}("
      value += if $.isNumeric(x) then "#{x}px, " else "#{x or ''}, "
      value += if $.isNumeric(y) then "#{y}px"   else (y or '')
      value += ')'

  @css(
    '-moz-transform':    value
    '-ms-transform':     value
    '-webkit-transform': value
    'transform':         value
  ) if value?
  this

$.fn.translate = ->
  args = ['translate']
  args.push(arguments[0]) if arguments.length > 0
  args.push(arguments[1]) if arguments.length > 1
  @transform.apply(this, args)