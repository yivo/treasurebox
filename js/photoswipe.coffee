galleryTemplate =
  '<div aria-hidden="true" id="pswp" class="pswp" role="dialog" tabindex="-1">
    <div class="pswp__bg"></div>
    <div class="pswp__scroll-wrap">
      <div class="pswp__container">
        <div class="pswp__item"></div>
        <div class="pswp__item"></div>
        <div class="pswp__item"></div>
      </div>
      <div class="pswp__ui pswp__ui--hidden">
        <div class="pswp__top-bar">
          <div class="pswp__counter"></div>
          <button class="pswp__button pswp__button--close" title="Закрыть (Esc)"></button>
          <button class="pswp__button pswp__button--share" title="Поделиться"></button>
          <button class="pswp__button pswp__button--fs" title="Полноэкранный режим"></button>
          <button class="pswp__button pswp__button--zoom" title="Увеличить/Уменьшить"></button>
          <div class="pswp__preloader">
            <div class="pswp__preloader__icn">
              <div class="pswp__preloader__cut">
                <div class="pswp__preloader__donut"></div>
              </div>
            </div>
          </div>
        </div>
        <div class="pswp__share-modal pswp__share-modal--hidden pswp__single-tap">
          <div class="pswp__share-tooltip"></div>
        </div>
        <button class="pswp__button pswp__button--arrow--left" title="Назад (стрелка влево)"></button>
        <button class="pswp__button pswp__button--arrow--right" title="Вперед (стрелка вправо)"></button>
        <div class="pswp__caption">
          <div class="pswp__caption__center"></div>
        </div>
      </div>
    </div>
  </div>'

createGallery = ($photo, $pswp) ->
  $scope  = $photo.parents('.js-photoswipe-scope')
  $photos = $scope.find('img:not([data-no-photoswipe])')

  # Initializing photoswipe with no images causes errors
  return unless $photos[0]

  descriptors = []

  $photos.each ->
    $el = $(this)
    if src = ($el.attr('data-url') or $el.attr('src'))
      value   = $el.attr('data-photoswipe-no-preshow')
      preshow = not value? or value in [false, 'false']

      obj =
        $el: $el
        src: src
        msrc: if preshow then $el.attr('data-thumb-url') or $el.attr('src')
        w: $el.attr('data-width') or $el.attr('width') or $el.prop('naturalWidth') or 800
        h: $el.attr('data-height') or $el.attr('height') or $el.prop('naturalHeight') or 600
        title: $el.siblings('figcaption')?.text?() || $el.attr('alt') || $el.attr('data-description')
      descriptors.push(obj)

  options =
    history: false
    index: $photos.index($photo)
    mainClass: 'pswp--minimal--dark'
    barsSize: top: 0, bottom: 0
    closeEl: true
    captionEl: true
    fullscreenEl: true
    zoomEl: true
    shareEl: false
    counterEl: true
    arrowEl: true
    preloaderEl: true
    bgOpacity: 0.85
    tapToClose: true
    tapToToggleControls: false
    closeOnScroll: false
    maxSpreadZoom: 1.2
    getThumbBoundsFn: (index) ->
      $el = descriptors[index]?.$el
      if $el?[0]
        value = $el.attr('data-photoswipe-no-thumb-animation')
        anim  = not value? or value in [false, 'false']
        if anim
          pageYScroll = window.pageYOffset or document.documentElement.scrollTop
          rect = $el[0].getBoundingClientRect()
          x: rect.left, y: rect.top + pageYScroll, w: rect.width

    getDoubleTapZoom: (isMouseClick, item) ->
      return 0.77 if isMouseClick
      if item.initialZoomLevel < 0.7 then 1 else 1.33

  new PhotoSwipe($pswp[0], PhotoSwipeUI_Default, descriptors, options)

$pswp = null

callback = ->
  $('#pswp').remove()
  $('body').append(galleryTemplate)
  $pswp = $('#pswp')
  return

if Turbolinks?
  if Turbolinks.supported
    $(document).on 'page:change', callback
  else
    $(callback)
else
  $(document).on 'ready pjax:end', callback

$ ->
  $(document).on 'click', [
    '.js-photoswipe-scope img:not([data-no-photoswipe])',
    '.js-photoswipe-scope .js-photoswipe'
  ].join(','), (e) ->
    $el = $(e.currentTarget)
    if $el.prop('tagName').toLowerCase() != 'img'
      $el = $el.find('img:not([data-no-photoswipe])')
    createGallery($el, $pswp)?.init()
    return

  $(document).on 'click', '.js-wysiwyg figure', (e) ->
    createGallery($(e.currentTarget).find('img'), $pswp)?.init()
    return