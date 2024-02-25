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
      "venditabant.widget.label.Standard": {},
      "venditabant.widget.textarea.Standard": {}
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);
  qx.Class.define("venditabant.application.base.views.Base", {
    extend: qx.core.Object,
    construct: function construct() {},
    destruct: function destruct() {},
    members: {
      _createChkBox: function _createChkBox(txt, clr, width, cb, ctx) {
        var btn = new venditabant.widget.button.Standard().createChkBox(txt, clr, width, cb, ctx);
        return btn;
      },
      _createBtn: function _createBtn(txt, clr, width, cb, ctx, toolTips) {
        var btn = new venditabant.widget.button.Standard().createBtn(txt, clr, width, cb, ctx, toolTips);
        return btn;
      },
      _createTxt: function _createTxt(placeholder, width, required, requiredTxt, toolTips) {
        var txt = new venditabant.widget.textfield.Standard().createTxt(placeholder, width, required, requiredTxt, toolTips);
        return txt;
      },
      _createLbl: function _createLbl(label, width, required, requiredTxt, toolTips) {
        var lbl = new venditabant.widget.label.Standard().createLbl(label, width, required, requiredTxt, toolTips);
        return lbl;
      },
      _createTextArea: function _createTextArea(placeholder, width, required, requiredTxt, toolTips) {
        var txt = new venditabant.widget.textarea.Standard();
        var txtarea = txt.createTxt(placeholder, width, required, requiredTxt, toolTips);
        return txtarea;
      }
    }
  });
  venditabant.application.base.views.Base.$$dbClassInfo = $$dbClassInfo;
})();

//# sourceMappingURL=Base.js.map?dt=1707927155423