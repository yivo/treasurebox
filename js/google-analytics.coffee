initializeGoogleAnalytics = do ->
  initialized = no

  (trackingID) ->
    return if initialized or not trackingID

    `(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','//www.google-analytics.com/analytics.js','ga');`

    ga('create', trackingID, 'auto')

    pageView = ->
      ga('send', 'pageview', location.href.split('#')[0])
      return

    if Turbolinks?
      if Turbolinks.supported
        $(document).on('page:change', pageView)
      else
        pageView()
    else
      pageView()
      $(document).on('pjax:end', pageView) if $.fn.pjax

    initialized = yes
    return

if head = document.getElementsByTagName('head')[0]
  meta       = head.getElementsByTagName('meta')
  trackingID = undefined

  for el in meta
    if el.getAttribute('name') is 'ga:tracking_id'
      trackingID = el.getAttribute('content')
      break

  initializeGoogleAnalytics(trackingID) if trackingID