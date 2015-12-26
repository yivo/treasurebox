initializeRollbar = do ->
  initialized = no

  (accessToken) ->
    return if initialized or not accessToken

    `
      var _rollbarConfig = {
        accessToken: accessToken,
        captureUncaught: true,
        payload: {
          environment: 'production'
        }
      };
      !function(r){function o(e){if(t[e])return t[e].exports;var n=t[e]={exports:{},id:e,loaded:!1};return r[e].call(n.exports,n,n.exports,o),n.loaded=!0,n.exports}var t={};return o.m=r,o.c=t,o.p="",o(0)}([function(r,o,t){"use strict";var e=t(1).Rollbar,n=t(2);_rollbarConfig.rollbarJsUrl=_rollbarConfig.rollbarJsUrl||"https://d37gvrvc0wt4s1.cloudfront.net/js/v1.7/rollbar.min.js";var a=e.init(window,_rollbarConfig),i=n(a,_rollbarConfig);a.loadFull(window,document,!_rollbarConfig.async,_rollbarConfig,i)},function(r,o){"use strict";function t(){var r=window.console;r&&"function"==typeof r.log&&r.log.apply(r,arguments)}function e(r,o){return o=o||t,function(){try{return r.apply(this,arguments)}catch(t){o("Rollbar internal error:",t)}}}function n(r,o,t){window._rollbarWrappedError&&(t[4]||(t[4]=window._rollbarWrappedError),t[5]||(t[5]=window._rollbarWrappedError._rollbarContext),window._rollbarWrappedError=null),r.uncaughtError.apply(r,t),o&&o.apply(window,t)}function a(r){var o=function(){var o=Array.prototype.slice.call(arguments,0);n(r,r._rollbarOldOnError,o)};return o.belongsToShim=!0,o}function i(r){this.shimId=++p,this.notifier=null,this.parentShim=r,this.logger=t,this._rollbarOldOnError=null}function l(r){var o=i;return e(function(){if(this.notifier)return this.notifier[r].apply(this.notifier,arguments);var t=this,e="scope"===r;e&&(t=new o(this));var n=Array.prototype.slice.call(arguments,0),a={shim:t,method:r,args:n,ts:new Date};return window._rollbarShimQueue.push(a),e?t:void 0})}function u(r,o){if(o.hasOwnProperty&&o.hasOwnProperty("addEventListener")){var t=o.addEventListener;o.addEventListener=function(o,e,n){t.call(this,o,r.wrap(e),n)};var e=o.removeEventListener;o.removeEventListener=function(r,o,t){e.call(this,r,o&&o._wrapped?o._wrapped:o,t)}}}var p=0;i.init=function(r,o){var t=o.globalAlias||"Rollbar";if("object"==typeof r[t])return r[t];r._rollbarShimQueue=[],r._rollbarWrappedError=null,o=o||{};var n=new i;return e(function(){if(n.configure(o),o.captureUncaught){n._rollbarOldOnError=r.onerror,r.onerror=a(n);var e,i,l="EventTarget,Window,Node,ApplicationCache,AudioTrackList,ChannelMergerNode,CryptoOperation,EventSource,FileReader,HTMLUnknownElement,IDBDatabase,IDBRequest,IDBTransaction,KeyOperation,MediaController,MessagePort,ModalWindow,Notification,SVGElementInstance,Screen,TextTrack,TextTrackCue,TextTrackList,WebSocket,WebSocketWorker,Worker,XMLHttpRequest,XMLHttpRequestEventTarget,XMLHttpRequestUpload".split(",");for(e=0;e<l.length;++e)i=l[e],r[i]&&r[i].prototype&&u(n,r[i].prototype)}return r[t]=n,n},n.logger)()},i.prototype.loadFull=function(r,o,t,n,a){var i=function(){var o;if(void 0===r._rollbarPayloadQueue){var t,e,n,i;for(o=new Error("rollbar.js did not load");t=r._rollbarShimQueue.shift();)for(n=t.args,i=0;i<n.length;++i)if(e=n[i],"function"==typeof e){e(o);break}}"function"==typeof a&&a(o)},l=!1,u=o.createElement("script"),p=o.getElementsByTagName("script")[0],s=p.parentNode;u.src=n.rollbarJsUrl,u.async=!t,u.onload=u.onreadystatechange=e(function(){if(!(l||this.readyState&&"loaded"!==this.readyState&&"complete"!==this.readyState)){u.onload=u.onreadystatechange=null;try{s.removeChild(u)}catch(r){}l=!0,i()}},this.logger),s.insertBefore(u,p)},i.prototype.wrap=function(r,o){try{var t;if(t="function"==typeof o?o:function(){return o||{}},"function"!=typeof r)return r;if(r._isWrap)return r;if(!r._wrapped){r._wrapped=function(){try{return r.apply(this,arguments)}catch(o){throw o._rollbarContext=t()||{},o._rollbarContext._wrappedSource=r.toString(),window._rollbarWrappedError=o,o}},r._wrapped._isWrap=!0;for(var e in r)r.hasOwnProperty(e)&&(r._wrapped[e]=r[e])}return r._wrapped}catch(n){return r}};for(var s="log,debug,info,warn,warning,error,critical,global,configure,scope,uncaughtError".split(","),c=0;c<s.length;++c)i.prototype[s[c]]=l(s[c]);r.exports={Rollbar:i,_rollbarWindowOnError:n}},function(r,o){"use strict";r.exports=function(r,o){return function(t){if(!t&&!window._rollbarInitialized){var e=window.RollbarNotifier,n=o||{},a=n.globalAlias||"Rollbar",i=window.Rollbar.init(n,r);i._processShimQueue(window._rollbarShimQueue||[]),window[a]=i,window._rollbarInitialized=!0,e.processPayloads()}}}}]);
    `
    return

if head = document.getElementsByTagName('head')[0]
  meta        = head.getElementsByTagName('meta')
  accessToken = undefined

  for el in meta
    if el.getAttribute('name') is 'rollbar:access_token'
      accessToken = el.getAttribute('content')
      break

  initializeRollbar(accessToken) if accessToken