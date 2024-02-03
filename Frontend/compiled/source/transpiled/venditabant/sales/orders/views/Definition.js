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
      "qx.ui.container.Stack": {},
      "venditabant.sales.orders.views.SalesordersList": {},
      "venditabant.sales.orders.views.Salesorder": {}
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);
  qx.Class.define("venditabant.sales.orders.views.Definition", {
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
      // Public functions ...
      getView: function getView() {
        var that = this;
        var view = new qx.ui.container.Composite(new qx.ui.layout.Canvas());
        view.setBackgroundColor("white");
        var container = new qx.ui.container.Stack();
        container.setDecorator("main");
        this._container = container;
        var salesorderlist = new venditabant.sales.orders.views.SalesordersList().set({
          support: this.isSupport(),
          callback: this
        });
        this._salesorderlist = salesorderlist;
        container.add(this._salesorderlist.getView());
        view.add(container, {
          top: 5,
          left: 5,
          right: 5,
          height: "95%"
        }); //this._tabView = tabView;

        return view;
      },
      setSalesorder: function setSalesorder(salesorders_fkey) {
        if (typeof this._salesorder === 'undefined' || this._salesorder === null) {
          var salesorder = new venditabant.sales.orders.views.Salesorder().set({
            support: this.isSupport(),
            salesorders_fkey: salesorders_fkey,
            callback: this
          });
          salesorder.loadOrder();
          this._salesorder = salesorder;

          this._container.add(this._salesorder.getView());
        } else {
          this._salesorder.setSalesorders_fkey(salesorders_fkey);
        }

        this._salesorder.loadOrder();

        this.nextViev();
      },
      nextViev: function nextViev() {
        this._container.next();
      },
      previousView: function previousView() {
        this._container.previous();
      }
    }
  });
  venditabant.sales.orders.views.Definition.$$dbClassInfo = $$dbClassInfo;
})();

//# sourceMappingURL=Definition.js.map?dt=1706805923417