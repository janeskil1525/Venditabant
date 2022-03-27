(function () {
  var $$dbClassInfo = {
    "dependsOn": {
      "qx.Class": {
        "usage": "dynamic",
        "require": true
      },
      "qx.core.Object": {
        "require": true
      }
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);
  qx.Class.define("venditabant.application.Const", {
    extend: qx.core.Object,
    // type: "singleton",
    construct: function construct() {},
    destruct: function destruct() {},
    members: {
      _mode: 'test',
      venditabant_endpoint: function venditabant_endpoint() {
        if (this._mode === 'test') {
          return 'http://192.168.1.134';
        } else {
          return 'https://www.venditabant.net';
        }
      },
      getVersion: function getVersion() {
        return "0.0.3";
      }
    }
  });
  venditabant.application.Const.$$dbClassInfo = $$dbClassInfo;
})();

//# sourceMappingURL=Const.js.map?dt=1648387791216