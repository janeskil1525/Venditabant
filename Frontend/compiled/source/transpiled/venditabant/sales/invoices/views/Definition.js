function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

(function () {
  var $$dbClassInfo = {
    "dependsOn": {
      "qx.Class": {
        "usage": "dynamic",
        "require": true
      },
      "qx.ui.window.Window": {
        "construct": true,
        "require": true
      },
      "qx.ui.layout.Canvas": {
        "construct": true
      },
      "qx.core.Init": {
        "construct": true
      },
      "qx.ui.layout.VBox": {},
      "qx.ui.basic.Atom": {},
      "qx.ui.tabview.TabView": {},
      "qx.ui.tabview.Page": {},
      "venditabant.communication.Post": {},
      "venditabant.widget.button.Standard": {},
      "qx.ui.table.model.Simple": {},
      "qx.ui.table.Table": {},
      "qx.ui.table.selection.Model": {},
      "venditabant.stock.stockitems.models.Stockitem": {},
      "venditabant.widget.textfield.Standard": {},
      "venditabant.widget.label.Standard": {}
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);
  qx.Class.define("venditabant.sales.invoices.views.Definition", {
    extend: qx.ui.window.Window,
    construct: function construct() {
      qx.ui.window.Window.constructor.call(this);
      this.setLayout(new qx.ui.layout.Canvas());
      this.setWidth(1000);
      this.setHeight(1000);

      this._buildWindow();

      var app = qx.core.Init.getApplication();
      var root = app.getRoot();
      root.add(this, {
        top: 10,
        left: 10
      });
    },
    destruct: function destruct() {},
    members: _defineProperty({
      // Public functions ...
      setParams: function setParams(params) {},
      _buildWindow: function _buildWindow() {
        var win = new qx.ui.window.Window("Invoices", "icon/16/apps/internet-feed-reader.png");
        win.setLayout(new qx.ui.layout.VBox(10));
        win.setStatus("Application is ready");
        win.open();
        var app = qx.core.Init.getApplication();
        var root = app.getRoot();
        root.add(win, {
          left: 350,
          top: 120
        });
        var atom = new qx.ui.basic.Atom("Manage invoices", "icon/22/apps/utilities-calculator.png");
        win.add(atom);
        win.setShowStatusbar(true);
        /*var box = new qx.ui.container.Composite();
        box.setLayout(new qx.ui.layout.HBox(10));
        win.add(box, {flex: 1});*/
        // Add a TabView

        var tabView = new qx.ui.tabview.TabView();
        tabView.setWidth(800);
        tabView.setHeight(400);
        win.add(tabView, {
          flex: 1
        });
        var page1 = new qx.ui.tabview.Page("Invoices");
        page1.setLayout(new qx.ui.layout.VBox(4));
        page1.setLayout(new qx.ui.layout.Canvas());

        this._createSoTable();

        page1.add(this._sotable);
        tabView.add(page1);
        var page2 = new qx.ui.tabview.Page("Invoice");
        page2.setLayout(new qx.ui.layout.Canvas());

        var lbl = this._createLbl(this.tr("Customer"), 70);

        page2.add(lbl, {
          top: 10,
          left: 10
        });
        lbl = this._createLbl(this.tr("Customer"), 70);
        page2.add(lbl, {
          top: 10,
          left: 90
        });
        lbl = this._createLbl(this.tr("Orderno"), 70);
        page2.add(lbl, {
          top: 10,
          left: 250
        });
        lbl = this._createLbl(this.tr("Orderno"), 70);
        page2.add(lbl, {
          top: 10,
          left: 350
        });
        lbl = this._createLbl(this.tr("Orderdate"), 70);
        page2.add(lbl, {
          top: 10,
          left: 450
        });
        lbl = this._createLbl(this.tr("Orderdate"), 70);
        page2.add(lbl, {
          top: 10,
          left: 550
        });
        /*let stockitem = this._createTxt(
            this.tr( "Stockitem" ),150,true,this.tr("Stockitem is required")
        );
         page2.add ( stockitem, { top: 10, left: 90 } );
        this._stockitem = stockitem;
         lbl = this._createLbl(this.tr( "Description" ),70);
        page2.add ( lbl, { top: 10, left: 250 } );
         let descriptn = this._createTxt(
            this.tr( "Description" ),250,true,this.tr("Description is required")
        );
        page2.add ( descriptn, { top: 10, left: 350 } );
        this._description = descriptn;
         lbl = this._createLbl(this.tr( "Price" ),70);
        page2.add ( lbl, { top: 50, left: 10 } );
         let price = this._createTxt(
            this.tr( "Price" ),80,false
        );
         page2.add ( price, { top: 50, left: 90 } );
        this._price = price;
         lbl = this._createLbl(this.tr( "PO price" ),70);
        page2.add ( lbl, { top: 50, left: 250 } );
         let purchprice = this._createTxt(
            this.tr( "Purchase price" ),80,false
        );
         page2.add ( purchprice, { top: 50, left: 350 } );
        this._purchaseprice = purchprice;
         lbl = this._createLbl(this.tr( "Active" ),70);
        page2.add ( lbl, { top: 90, left: 10 } );
         let active = new qx.ui.form.CheckBox("");
        page2.add ( active, { top: 90, left: 90 } );
        this._active = active;
         lbl = this._createLbl(this.tr( "Stocked" ),70);
        page2.add ( lbl, { top: 90, left: 250 } );
         let stocked = new qx.ui.form.CheckBox("");
        page2.add ( stocked, { top: 90, left: 350 } );
        this._stocked = stocked;
         let btnSignup = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 135, function ( ) {
            this.saveStockitem ( );
        }, this );
        page2.add ( btnSignup, { bottom: 10, left: 10 } );
         let btnCancel = this._createBtn ( this.tr ( "Cancel" ), "#FFAAAA70", 135, function ( ) {
            this.cancel ( );
        }, this );
        page2.add ( btnCancel, { bottom: 10, right: 10 } );*/

        tabView.add(page2);
        /*var page2 = new qx.ui.tabview.Page("Page 2");
        tabView.add(page2);
         var page3 = new qx.ui.tabview.Page("Page 3");
        tabView.add(page3);*/
        //this.loadStockitems();
      },
      saveStockitem: function saveStockitem() {
        var stockitem = this._stockitem.getValue();

        var description = this._description.getValue();

        var price = this._price.getValue();

        var purchaseprice = this._purchaseprice.getValue();

        var active = this._active.getValue();

        var stocked = this._stocked.getValue();

        var date = new Date();
        var today = date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate();
        var fiveyears = date.getFullYear() + 5 + '-' + (date.getMonth() + 1) + '-' + date.getDate();
        var data = {
          stockitem: stockitem,
          description: description,
          price: price,
          purchaseprice: purchaseprice,
          active: active,
          stocked: stocked,
          fromdate: today,
          todate: fiveyears
        };
        var com = new venditabant.communication.Post();
        com.send(this._address, "/api/v1/stockitem/save/", data, function (success) {
          var win = null;

          if (success) {
            this.loadStockitems();
            alert("Saved item successfully");
          } else {
            alert(this.tr('success'));
          }
        }, this);
      },
      _createBtn: function _createBtn(txt, clr, width, cb, ctx) {
        var btn = new venditabant.widget.button.Standard().createBtn(txt, clr, width, cb, ctx);
        return btn;
      },
      _createSoTable: function _createSoTable() {
        // Create the initial data
        var rowData = '';
        var that = this; // table model

        var tableModel = new qx.ui.table.model.Simple();
        tableModel.setColumns(["ID", "Customer", "Orderno", "Order date", "Delivery date", "Open"]);
        tableModel.setData(rowData); // table

        var table = new qx.ui.table.Table(tableModel);
        table.set({
          width: 800,
          height: 345
        });
        table.getSelectionModel().setSelectionMode(qx.ui.table.selection.Model.SINGLE_SELECTION);
        table.getSelectionModel().addListener('changeSelection', function (e) {
          var selectionModel = e.getTarget();
          var selectedRows = [];
          selectionModel.iterateSelection(function (index) {
            selectedRows.push(table.getTableModel().getRowData(index));
          });
        });
        var tcm = table.getTableColumnModel();
        this._sotable = table;
      },
      loadStockitems: function loadStockitems() {
        var stockitems = new venditabant.stock.stockitems.models.Stockitem();
        stockitems.loadList(function (response) {
          var tableData = [];

          for (var i = 0; i < response.data.length; i++) {
            var active = response.data[i].active ? true : false;
            var stocked = response.data[i].stocked ? true : false;
            tableData.push([response.data[i].stockitems_pkey, response.data[i].stockitem, response.data[i].description, response.data[i].price, response.data[i].purchaseprice, active, stocked]);
          }

          this._table.getTableModel().setData(tableData); //alert("Set table data here");

        }, this); //return ;//list;
      },
      _createTxt: function _createTxt(placeholder, width, required, requiredTxt) {
        var txt = new venditabant.widget.textfield.Standard().createTxt(placeholder, width, required, requiredTxt);
        return txt;
      },
      _createLbl: function _createLbl(label, width, required, requiredTxt) {
        var lbl = new venditabant.widget.label.Standard().createLbl(label, width, required, requiredTxt);
        return lbl;
      }
    }, "_createBtn", function _createBtn(txt, clr, width, cb, ctx) {
      var btn = new venditabant.widget.button.Standard().createBtn(txt, clr, width, cb, ctx);
      return btn;
    })
  });
  venditabant.sales.invoices.views.Definition.$$dbClassInfo = $$dbClassInfo;
})();

//# sourceMappingURL=Definition.js.map?dt=1632848848797