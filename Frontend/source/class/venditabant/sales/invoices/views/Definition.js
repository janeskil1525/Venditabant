
qx.Class.define ( "venditabant.sales.invoices.views.Definition",
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
                let view = new qx.ui.container.Composite(new qx.ui.layout.Canvas());
                view.setBackgroundColor("white");

                /*var box = new qx.ui.container.Composite();
                box.setLayout(new qx.ui.layout.HBox(10));
                win.add(box, {flex: 1});*/
                var container = new qx.ui.container.Stack();
                container.setDecorator("main");
                this._container = container;

                let invoicelist = new venditabant.sales.invoices.views.InvoiceList().set({
                    support:this.isSupport(),
                    callback:this,
                });
                this._invoicelist = invoicelist;
                container.add(this._invoicelist.getView());
                // Add a TabView

                view.add(container, {top:5, left:5, right:5,height:"95%"});
                return view;

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
            _createInvTable : function() {
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

                this._invtable = table;
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
        }
    });
