
qx.Class.define ( "venditabant.sales.orders.views.Definition",
    {
        extend: venditabant.application.base.views.Base,
        include:[qx.locale.MTranslation],
        construct: function () {
        },
        destruct: function () {
        },
        properties : {
            support : { nullable : true, check: "Boolean" }
        },
        members: {
            // Public functions ...

            setParams: function (params) {
            },
            getView: function () {
                let that = this;
                let view = new qx.ui.container.Composite(new qx.ui.layout.Canvas());
                view.setBackgroundColor("white");

                // Add a TabView
                var tabView = new qx.ui.tabview.TabView();
                //view.add(tabView, {top: 0, left: 5, right: 5, height: "90%"});

                var page1 = new qx.ui.tabview.Page("Salesorders");
                page1.setLayout(new qx.ui.layout.Canvas());

                let lbl = this._createLbl(this.tr( "Open" ),70);
                page1.add ( lbl, { top: 10, left: 10 } );

                let open = new qx.ui.form.CheckBox("");
                this._open = open;
                this._open.setValue(true);
                open.addListener('changeValue',function() {
                    that.loadSalesorderList();
                })
                page1.add ( open, { top: 10, left: 90 } );



                this._createSoTable();

                page1.add(this._sotable,{top: 50, left:5, right:5, height:"90%"});
                tabView.add(page1);

                var page2 = new qx.ui.tabview.Page("Salesorder");
                page2.setLayout(new qx.ui.layout.Canvas());

                lbl = this._createLbl(this.tr( "Customer" ),70);
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

                view.add(tabView, {top:5, left:5, right:5,height:"95%"});
                this.loadSalesorderList();
                return view;

            },
            _createSoTable : function() {
                // Create the initial data
                let rowData =  '';
                let that = this;

                // table model
                var tableModel = new qx.ui.table.model.Simple();
                tableModel.setColumns(
                    [ "ID", "Customer", "Orderno", "Order date","Delivery date","Open", "customers_fkey", "users_fkey" ]
                );
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
                tcm.setColumnVisible(0,false);
                tcm.setColumnVisible(6,false);
                tcm.setColumnVisible(7,false);
                tcm.setColumnWidth(1,300);
                tcm.setDataCellRenderer(5, new qx.ui.table.cellrenderer.Boolean());

                this._sotable = table;
            },
            loadSalesorderList:function () {
                let salesorders = new venditabant.sales.orders.models.Salesorders();
                salesorders.loadSalesorderList(function(response) {
                    let tableData = [];
                    for(let i = 0; i < response.data.length; i++) {
                        let open = response.data[i].open ? true : false;
                        tableData.push([
                                response.data[i].salesorders_pkey,
                                response.data[i].customer,
                                response.data[i].orderno,
                                response.data[i].orderdate,
                                response.data[i].deliverydate,
                                open,
                                response.data[i].customers_fkey,
                                response.data[i].users_fkey,
                            ]);
                    }
                    this._sotable.getTableModel().setData(tableData);
                    //alert("Set table data here");
                }, this, this._open.getValue());
                //return ;//list;
            }
        }
    });
