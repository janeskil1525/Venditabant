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
          return 'http://192.168.1.116';
        } else {
          return 'https://www.venditabant.net';
        }
      },
      getVersion: function getVersion() {
        return "0.1.3";
      },
      venditabant_port: function venditabant_port() {
        if (this._mode === 'test') {
          return '30001';
        } else {
          return '3000';
        }
      }
    }
  });
  venditabant.application.Const.$$dbClassInfo = $$dbClassInfo;
})();

//# sourceMappingURL=Const.js.map?dt=1707998942229