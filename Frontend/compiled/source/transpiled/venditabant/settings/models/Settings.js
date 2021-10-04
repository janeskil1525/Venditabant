(function () {
  var $$dbClassInfo = {
    "dependsOn": {
      "qx.Class": {
        "usage": "dynamic",
        "require": true
      },
      "qx.core.Object": {
        "require": true
      },
      "venditabant.application.Const": {
        "usage": "dynamic",
        "require": true
      },
      "venditabant.communication.Get": {}
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);
  qx.Class.define("venditabant.settings.models.Settings", {
    extend: qx.core.Object,
    construct: function construct() {},
    destruct: function destruct() {},
    members: {
      _address: new venditabant.application.Const().venditabant_endpoint(),
      loadList: function loadList(cb, ctx, setting) {
        var get = new venditabant.communication.Get();
        get.load(this._address, "/api/v1/parameters/load_list/", setting, function (response) {
          cb.call(ctx, response);
        }, this);
      }
    }
  });
  venditabant.settings.models.Settings.$$dbClassInfo = $$dbClassInfo;
})();

//# sourceMappingURL=Settings.js.map?dt=1633348427000