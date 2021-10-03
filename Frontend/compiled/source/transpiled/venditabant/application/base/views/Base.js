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
      "venditabant.widget.button.Standard": {},
      "venditabant.widget.textfield.Standard": {},
      "venditabant.widget.label.Standard": {}
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);
  qx.Class.define("venditabant.application.base.views.Base", {
    extend: qx.core.Object,
    construct: function construct() {},
    destruct: function destruct() {},
    members: {
      _createBtn: function _createBtn(txt, clr, width, cb, ctx) {
        var btn = new venditabant.widget.button.Standard().createBtn(txt, clr, width, cb, ctx);
        return btn;
      },
      _createTxt: function _createTxt(placeholder, width, required, requiredTxt) {
        var txt = new venditabant.widget.textfield.Standard().createTxt(placeholder, width, required, requiredTxt);
        return txt;
      },
      _createLbl: function _createLbl(label, width, required, requiredTxt) {
        var lbl = new venditabant.widget.label.Standard().createLbl(label, width, required, requiredTxt);
        return lbl;
      }
    }
  });
  venditabant.application.base.views.Base.$$dbClassInfo = $$dbClassInfo;
})();

//# sourceMappingURL=Base.js.map?dt=1633266123239