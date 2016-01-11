NProgress.configure(showSpinner: no, trickleRate: 0.1)

if Turbolinks?
  $(document).on 'page:fetch',   -> NProgress.start()
  $(document).on 'page:receive', -> NProgress.set(0.7)
  $(document).on 'page:change',  -> NProgress.done()
  $(document).on 'page:restore', -> NProgress.remove()

else if $.fn.pjax
  # TODO