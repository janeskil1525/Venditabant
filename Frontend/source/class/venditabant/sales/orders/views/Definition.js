
qx.Class.define ( "venditabant.sales.orders.views.Definition",
    {
        extend: qx.ui.window.Window,

        construct: function () {
            this.base(arguments);
            this.setLayout(new qx.ui.layout.Canvas());
            this.setWidth(1000);
            this.setHeight(1000);
            this._buildWindow();
            var app = qx.core.Init.getApplication();
            var root = app.getRoot();
            root.add(this, {top: 10, left: 10});

        },
        destruct: function () {
        },

        members: {
            // Public functions ...

            setParams: function (params) {
            },
            _buildWindow: function () {
                var win = new qx.ui.window.Window("Salesorder", "icon/16/apps/internet-feed-reader.png");
                win.setLayout(new qx.ui.layout.VBox(10));
                win.setStatus("Application is ready");
                win.open();
                let app = qx.core.Init.getApplication();
                let root = app.getRoot();
                root.add(win, {left: 350, top: 120});

                var atom = new qx.ui.basic.Atom("Manage salesorders", "icon/22/apps/utilities-calculator.png");
                win.add(atom);
                win.setShowStatusbar(true);

                /*var box = new qx.ui.container.Composite();
                box.setLayout(new qx.ui.layout.HBox(10));
                win.add(box, {flex: 1});*/

                // Add a TabView
                var tabView = new qx.ui.tabview.TabView();
                tabView.setWidth(800);
                tabView.setHeight(400);
                win.add(tabView, {flex:1});

                var page1 = new qx.ui.tabview.Page("Salesorders");
                page1.setLayout(new qx.ui.layout.VBox(4));
                page1.setLayout(new qx.ui.layout.Canvas());

                this._createSoTable();

                page1.add(this._sotable);
                tabView.add(page1);

                var page2 = new qx.ui.tabview.Page("Salesorder");
                page2.setLayout(new qx.ui.layout.Canvas());

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
            saveStockitem:function() {
                let stockitem = this._stockitem.getValue();
                let description  = this._description.getValue();
                let price  = this._price.getValue();
                let purchaseprice  = this._purchaseprice.getValue();
                let active  = this._active.getValue();
                let stocked  = this._stocked.getValue();

                var date = new Date();
                var today = date.getFullYear()+'-'+(date.getMonth()+1)+'-'+date.getDate();
                var fiveyears = (date.getFullYear()+5)+'-'+(date.getMonth()+1)+'-'+date.getDate();

                let data = {
                    stockitem: stockitem,
                    description: description,
                    price:price,
                    purchaseprice:purchaseprice,
                    active:active,
                    stocked:stocked,
                    fromdate: today,
                    todate:fiveyears
                }
                let com = new venditabant.communication.Post ( );
                com.send ( this._address, "/api/v1/stockitem/save/", data, function ( success ) {
                    let win = null;
                    if ( success )  {
                        this.loadStockitems();
                        alert("Saved item successfully");
                    }
                    else  {
                        alert ( this.tr ( 'success' ) );
                    }
                }, this );

            },
            _createBtn : function (txt, clr, width, cb, ctx) {
                let btn = new venditabant.widget.button.Standard().createBtn(txt, clr, width, cb, ctx)

                return btn;
            },
            _createSoTable : function() {
                // Create the initial data
                let rowData =  '';
                let that = this;

                // table model
                var tableModel = new qx.ui.table.model.Simple();
                tableModel.setColumns([ "ID", "Customer", "Orderno", "Order date","Delivery date","Open" ]);
                tableModel.setData(rowData);
                // table
                var table = new qx.ui.table.Table(tableModel);

                table.set({
                    width: 800,
                    height: 345
                });

                table.getSelectionModel().setSelectionMode(qx.ui.table.selection.Model.SINGLE_SELECTION);
                table.getSelectionModel().addListener('changeSelection', function(e){
                    var selectionModel = e.getTarget();
                    var selectedRows = [];
                    selectionModel.iterateSelection(function(index) {
                        selectedRows.push(table.getTableModel().getRowData(index));
                    });

                });
                var tcm = table.getTableColumnModel();

                this._sotable = table;
            },
            loadStockitems:function () {
                let stockitems = new venditabant.stock.stockitems.models.Stockitem();
                stockitems.loadList(function(response) {
                    let tableData = [];
                    for(let i = 0; i < response.data.length; i++) {
                        let active = response.data[i].active ? true : false;
                        let stocked = response.data[i].stocked ? true : false;
                        tableData.push([
                            response.data[i].stockitems_pkey,
                            response.data[i].stockitem,
                            response.data[i].description,
                            response.data[i].price,
                            response.data[i].purchaseprice,
                            active,
                            stocked,
                            ]);
                    }
                    this._table.getTableModel().setData(tableData);
                    //alert("Set table data here");
                }, this);
                //return ;//list;
            },
            _createTxt:function(placeholder, width, required, requiredTxt) {
                let txt = new venditabant.widget.textfield.Standard().createTxt(placeholder, width, required, requiredTxt);
                return txt;
            },
            _createLbl:function(label, width, required, requiredTxt) {
                let lbl = new venditabant.widget.label.Standard().createLbl(label, width, required, requiredTxt);
                return lbl;
            },
            _createBtn : function (txt, clr, width, cb, ctx) {
                let btn = new venditabant.widget.button.Standard().createBtn(txt, clr, width, cb, ctx)

                return btn;
            },
        }
    });
