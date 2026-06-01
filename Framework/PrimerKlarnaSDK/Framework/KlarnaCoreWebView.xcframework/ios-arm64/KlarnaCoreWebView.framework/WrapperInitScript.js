"use strict";

(function () {
  if (document.readyState === "complete") {
    var _notifyMessageBridge = function notifyMessageBridge() {
      if (window.__KlarnaNativeHook != null) {
        console.log("Klarna Native Hook was notified");
        window.__KlarnaNativeHook.setNativeReady();
        foundMessageBridge = true;
      } else {
        window.setTimeout(_notifyMessageBridge, 50);
      }
    };
    var foundMessageBridge = false;
    _notifyMessageBridge();
  }
  window.addEventListener('load', function () {
    var interval = null;
    var notifyMessageBridge = function notifyMessageBridge() {
      if (window.__KlarnaNativeHook != null) {
        window.__KlarnaNativeHook.setNativeReady();
        clearInterval(interval);
      }
    };
    interval = setInterval(notifyMessageBridge, 50);
  });
})();