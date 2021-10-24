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
      "venditabant.sales.invoices.views.InvoiceList": {},
      "venditabant.communication.Post": {},
      "qx.ui.table.model.Simple": {},
      "qx.ui.table.Table": {},
      "qx.ui.table.selection.Model": {},
      "venditabant.stock.stockitems.models.Stockitem": {}
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);
  qx.Class.define("venditabant.sales.invoices.views.Definition", {
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
      setParams: function setParams(params) {},
      getView: function getView() {
        var view = new qx.ui.container.Composite(new qx.ui.layout.Canvas());
        view.setBackgroundColor("white");
        /*var box = new qx.ui.container.Composite();
        box.setLayout(new qx.ui.layout.HBox(10));
        win.add(box, {flex: 1});*/

        var container = new qx.ui.container.Stack();
        container.setDecorator("main");
        this._container = container;
        var invoicelist = new venditabant.sales.invoices.views.InvoiceList().set({
          support: this.isSupport(),
          callback: this
        });
        this._invoicelist = invoicelist;
        container.add(this._invoicelist.getView()); // Add a TabView

        view.add(container, {
          top: 5,
          left: 5,
          right: 5,
          height: "95%"
        });
        return view;
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
      _createInvTable: function _createInvTable() {
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
        this._invtable = table;
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
      }
    }
  });
  venditabant.sales.invoices.views.Definition.$$dbClassInfo = $$dbClassInfo;
})();

//# sourceMappingURL=Definition.js.map?dt=1635088717882