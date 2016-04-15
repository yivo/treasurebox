initialize = do ->
  initialized = no

  (counterID, options) ->
    return if initialized

    metrika = null
    (window.yandex_metrika_callbacks ?= []).push ->
      try metrika = new Ya.Metrika($.extend(id: counterID, options, defer: yes))

    `var n = document.getElementsByTagName("script")[0];
     var s = document.createElement("script");
     var f = function() { n.parentNode.insertBefore(s, n); };
     s.type  = "text/javascript";
     s.async = true;
     s.src   = "https://mc.yandex.ru/metrika/watch.js";
     if (window.opera == "[object Opera]") {
       d.addEventListener("DOMContentLoaded", f, false);
     } else {
       f();
     }`

    hit = -> metrika?.hit?(location.href.split('#')[0], title: document.title); return

    if Turbolinks?
      if Turbolinks.supported
        $(document).on('page:change', hit)
      else
        hit()
    else
      hit()
      $(document).on('pjax:end', hit) if $.fn.pjax

    initialized = yes
    return

if (head = document.getElementsByTagName('head')[0])?
  meta      = head.getElementsByTagName('meta')
  counterID = null
  options   = null

  for el in meta
    if el.getAttribute('name') is 'yandex_metrika:counter_id'
      counterID   = el.getAttribute('content')
    else if el.getAttribute('name') is 'yandex_metrika:options'
      try options = JSON.parse(el.getAttribute('content'))

  initialize(counterID, options) if counterID?