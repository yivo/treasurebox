initializeJivo = do ->
  initialized = no

  (widgetID) ->
    return if initialized or not widgetID

    s       = document.createElement('script')
    s.type  = 'text/javascript'
    s.async = true
    s.src   = '//code.jivosite.com/script/widget/' + widgetID
    ss      = document.getElementsByTagName('script')[0]
    ss.parentNode.insertBefore(s, ss)

    initialized = yes
    return

if head = document.getElementsByTagName('head')[0]
  meta     = head.getElementsByTagName('meta')
  widgetID = undefined

  for el in meta
    if el.getAttribute('name') is 'jivo:widget_id'
      widgetID = el.getAttribute('content')
      break

  initializeJivo(widgetID) if widgetID