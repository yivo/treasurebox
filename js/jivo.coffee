initializeJivo = do ->
  initialized = no

  (widgetID) ->
    return if initialized

    script       = document.createElement('script')
    script.type  = 'text/javascript'
    script.async = true
    script.src   = 'https://code.jivosite.com/script/widget/' + widgetID
    document.getElementsByTagName('head')[0]?.appendChild(script)
    initialized  = yes
    return

if (head = document.getElementsByTagName('head')[0])?
  meta     = head.getElementsByTagName('meta')
  widgetID = null

  for el in meta
    if el.getAttribute('name') is 'jivo:widget_id'
      widgetID = el.getAttribute('content')
      break

  initializeJivo(widgetID) if widgetID