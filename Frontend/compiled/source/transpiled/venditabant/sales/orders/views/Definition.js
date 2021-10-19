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
        this._container = container; //container.setWidth(200);
        //container.setHeight(120);
        // Add a TabView
        //var tabView = new qx.ui.tabview.TabView();
        //view.add(tabView, {top: 0, left: 5, right: 5, height: "90%"});

        var salesorderlist = new venditabant.sales.orders.views.SalesordersList().set({
          support: this.isSupport(),
          callback: this
        });
        this._salesorderlist = salesorderlist;
        container.add(this._salesorderlist.getView());
        /*page2.setLayout(new qx.ui.layout.Canvas());
         let lbl = this._createLbl(this.tr( "Customer" ),70);
        page2.add ( lbl, { top: 10, left: 10 } );
         lbl = this._createLbl(this.tr( "Customer" ),70);
        page2.add ( lbl, { top: 10, left: 90 } );
         lbl = this._createLbl(this.tr( "Orderno" ),70);
        page2.add ( lbl, { top: 10, left: 250 } );
         lbl = this._createLbl(this.tr( "Orderno" ),70);
        page2.add ( lbl, { top: 10, left: 350 } );
         lbl = this._createLbl(this.tr( "Orderdate" ),70);
        page2.add ( lbl, { top: 10, left: 450 } );
         lbl = this._createLbl(this.tr( "Orderdate" ),70);
        page2.add ( lbl, { top: 10, left: 550 } );
         tabView.add(page2);*/

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

//# sourceMappingURL=Definition.js.map?dt=1634652962396