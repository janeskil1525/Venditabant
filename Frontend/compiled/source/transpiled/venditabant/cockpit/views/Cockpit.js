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
      "qx.ui.container.Composite": {},
      "qx.ui.layout.Canvas": {}
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);
  qx.Class.define("venditabant.cockpit.views.Cockpit", {
    extend: qx.core.Object,
    construct: function construct() {},
    destruct: function destruct() {},
    members: {
      getView: function getView() {
        var stack = new qx.ui.container.Composite(new qx.ui.layout.Canvas()); //this.add(stack, {left: 5, top: 50, right: 5, height:"86%"});

        stack.setBackgroundColor("green"); //this._stack = stack;

        return stack;
      }
    }
  });
  venditabant.cockpit.views.Cockpit.$$dbClassInfo = $$dbClassInfo;
})();

//# sourceMappingURL=Cockpit.js.map?dt=1633181191565