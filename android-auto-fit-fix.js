// http://www.matt-helps.com/android-browser-auto-fit-fix/

(function() {
    var ua = navigator.userAgent.toLowerCase();
    var is4xAndroid = ua.indexOf('android 4.') > -1;
    var isNativeAndroidBrowser = ua.indexOf('mozilla/5.0') > -1 && ua.indexOf('android ') > -1 && ua.indexOf('applewebkit') > -1 && ua.indexOf('chrome') < 0;

    if (is4xAndroid && isNativeAndroidBrowser) {
        var head = document.getElementsByTagName('head')[0];
        var style = document.createElement('style');
        style.setAttribute('type', 'text/css');
        style.innerHTML = 'div,p,h1,h2,h3,h4,h5,h6,section,header,footer,ul,ol,dl,pre,blockquote{' +
            'background-image: url(data:image/gif;base64R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==);' +
            'background-repeat: repeat;}';
        head.appendChild(style);
    }
})();