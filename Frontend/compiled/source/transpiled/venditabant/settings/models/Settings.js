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
      "qx.locale.MTranslation": {
        "require": true
      },
      "venditabant.application.Const": {
        "usage": "dynamic",
        "require": true
      },
      "venditabant.communication.Get": {},
      "venditabant.communication.Post": {}
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);
  qx.Class.define("venditabant.settings.models.Settings", {
    extend: qx.core.Object,
    include: [qx.locale.MTranslation],
    construct: function construct() {},
    destruct: function destruct() {},
    members: {
      _address: new venditabant.application.Const().venditabant_endpoint(),
      loadList: function loadList(cb, ctx, setting) {
        var get = new venditabant.communication.Get();
        get.load(this._address, "/api/v1/parameters/load_list/", setting, function (response) {
          cb.call(ctx, response);
        }, this);
      },
      saveSetting: function saveSetting(data, cb, ctx) {
        var com = new venditabant.communication.Post();
        com.send(this._address, "/api/v1/parameters/save/", data, function (success) {
          if (success) {
            cb.call(ctx, data);
          } else {
            alert(this.tr('success'));
          }
        }, this);
      },
      deleteSetting: function deleteSetting(data, cb, ctx) {
        var com = new venditabant.communication.Post();
        com.send(this._address, "/api/v1/parameters/delete/", data, function (success) {
          if (success) {
            cb.call(ctx, data);
          } else {
            alert(this.tr('success'));
          }
        }, this);
      }
    }
  });
  venditabant.settings.models.Settings.$$dbClassInfo = $$dbClassInfo;
})();

//# sourceMappingURL=Settings.js.map?dt=1633786746377