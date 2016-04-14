module = @Treasurebox ||= {}

module.loadGoogleMapsAPI = do ->
  loaded  = no
  loading = no
  queue   = []

  gmProperty          = "__#{Date.now?() or +new Date()}GoogleMapsCallback"
  window[gmProperty]  = ->
    delete window[gmProperty]
    loaded  = yes
    loading = no
    item() for item in queue
    return

  (callback) ->
    if loaded
      callback()

    else
      queue.push(callback)

      unless loading
        if (head = document.getElementsByTagName('head')[0])?
          script      = document.createElement('script')
          script.type = 'text/javascript'
          script.src  = "http://maps.googleapis.com/maps/api/js?v=3&callback=#{gmProperty}"
          head.appendChild(script)
          loading = yes
    return