
qx.Class.define ( "venditabant.sales.orders.views.SalesordersList",
    {
        extend: venditabant.application.base.views.Base,
        include: [qx.locale.MTranslation],
        construct: function () {
        },
        destruct: function () {
        },
        properties: {
            support: {nullable: true, check: "Boolean"},
            callback:{nullable:true},
        },
        members: {
            _salesorders_fkey:0,
            getView: function () {
                let that = this;

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

                let btnNew = this._createBtn ( this.tr ( "New" ), "#FFAAAA70", 90, function ( ) {
                    this.getCallback().setSalesorder(0);
                }, this );
                page1.add ( btnNew, { top: 10, right: 10 } );


                page1.add(this._sotable,{top: 50, left:5, right:5, height:"90%"});
                this.loadSalesorderList();
                return page1;

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

                    that._salesorders_fkey = selectedRows[0][0];

                });
                table.addListener('cellDbltap', function(e){
                    that.getCallback().setSalesorder(that._salesorders_fkey);
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
                    if(response.data !== null) {
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
                    }

                    //alert("Set table data here");
                }, this, this._open.getValue());
                //return ;//list;
            }
        }
    });