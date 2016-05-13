initialize = do ->
  initialized = no

  (trackingID) ->
    return if initialized

    ga = ->
      args = []
      len  = arguments.length
      idx  = -1
      args.push(arguments[idx]) while ++idx < len
      (ga.q ?= []).push(args)
      return
      
    ga.l = Date.now?() ? +new Date()

    window.GoogleAnalyticsObject         = 'ga'
    window[window.GoogleAnalyticsObject] = ga

    script       = document.createElement('script')
    script.type  = 'text/javascript'
    script.async = true
    script.src   = 'https://www.google-analytics.com/analytics.js'
    document.getElementsByTagName('head')[0]?.appendChild(script)

    ga('create', trackingID, 'auto')

    pageView = -> ga('send', 'pageview', location.href.split('#')[0]); return

    if Turbolinks?
      if Turbolinks.supported
        $(document).on('page:change', pageView)
      else
        pageView()
    else
      pageView()
      $(document).on('pjax:end', pageView) if $.fn.pjax?

    initialized = yes
    return

if (head = document.getElementsByTagName('head')[0])?
  meta       = head.getElementsByTagName('meta')
  trackingID = undefined

  for el in meta
    if el.getAttribute('name') is 'ga:tracking_id'
      trackingID = el.getAttribute('content')
      break

  initialize(trackingID) if trackingID