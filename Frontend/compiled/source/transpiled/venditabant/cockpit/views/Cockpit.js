(function () {
  var $$dbClassInfo = {
    "dependsOn": {
      "qx.Class": {
        "usage": "dynamic",
        "require": true
      },
      "venditabant.application.base.views.Base": {
        "require": true
      },
      "qx.locale.MTranslation": {
        "require": true
      },
      "qx.ui.container.Composite": {},
      "qx.ui.layout.Canvas": {},
      "qx.ui.tabview.TabView": {},
      "venditabant.cockpit.views.AutoTodo": {},
      "qx.ui.tabview.Page": {}
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);
  qx.Class.define("venditabant.cockpit.views.Cockpit", {
    extend: venditabant.application.base.views.Base,
    include: [qx.locale.MTranslation],
    construct: function construct() {},
    destruct: function destruct() {},
    properties: {
      support: {
        nullable: true,
        check: "Boolean"
      }
    },
    members: {
      getView: function getView() {
        var view = new qx.ui.container.Composite(new qx.ui.layout.Canvas());
        var tabView = new qx.ui.tabview.TabView(); // tabView.setWidth(800);
        // tabView.setHeight(300);

        view.add(tabView, {
          top: 0,
          left: 5,
          right: 5,
          height: "100%"
        });
        var page1 = new venditabant.cockpit.views.AutoTodo();
        this._page1 = page1;
        var page2 = new qx.ui.tabview.Page("Status");
        page2.setLayout(new qx.ui.layout.Canvas());
        tabView.add(page1.getView());
        tabView.add(page2);
        return view;
      }
    }
  });
  venditabant.cockpit.views.Cockpit.$$dbClassInfo = $$dbClassInfo;
})();

//# sourceMappingURL=Cockpit.js.map?dt=1706805924772