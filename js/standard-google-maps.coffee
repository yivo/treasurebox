initializeGoogleMaps = ->
  if ($maps = $('.js-standard-google-map'))[0]
    Treasurebox.loadGoogleMapsAPI ->
      $maps.each ->
        $map   = $(this)
        center = new google.maps.LatLng($map.data('lat'), $map.data('lng'))
        zoom   = $map.data('zoom') or 17
        map    = new google.maps.Map(this, {center, zoom, scrollwheel: no, draggable: !isMobile?.any})
        marker = new google.maps.Marker {position: center, map, animation: google.maps.Animation.BOUNCE}
  return

if Turbolinks?
  if Turbolinks.supported
    $(document).on('page:change', initializeGoogleMaps)
  else
    $(initializeGoogleMaps)
else
  $(document).on('ready pjax:end', initializeGoogleMaps)