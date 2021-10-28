
qx.Class.define ( "venditabant.sales.invoices.views.InvoiceList",
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
            _invoice_fkey:0,
            getView: function () {
                let that = this;

                var page1 = new qx.ui.tabview.Page("Invoice");
                page1.setLayout(new qx.ui.layout.Canvas());

                let lbl = this._createLbl(this.tr( "Open" ),70);
                page1.add ( lbl, { top: 10, left: 10 } );

                let open = new qx.ui.form.CheckBox("");
                this._open = open;
                this._open.setValue(true);
                open.addListener('changeValue',function() {
                    that.loadInvoiceList();
                })
                page1.add ( open, { top: 10, left: 90 } );
                this._createTable();

                let btnNew = this._createBtn ( this.tr ( "New" ), "#FFAAAA70", 90, function ( ) {
                    this.getCallback().setInvoice(0);
                }, this );
                page1.add ( btnNew, { top: 10, right: 10 } );


                page1.add(this._table,{top: 50, left:5, right:5, height:"90%"});
                this.loadInvoiceList();
                return page1;

            },
            _createTable : function() {
                // Create the initial data
                let rowData =  '';
                let that = this;

                // table model
                var tableModel = new qx.ui.table.model.Simple();
                tableModel.setColumns(
                    [ "ID", "Customer", "Invoiceno", "Invoice date","Pay date","Open", "customers_fkey" ]
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

                    that._invoice_fkey = selectedRows[0][0];

                });
                table.addListener('cellDbltap', function(e){
                    that.getCallback().setInvoice(that._invoice_fkey);
                });

                var tcm = table.getTableColumnModel();
                tcm.setColumnVisible(0,false);
                //tcm.setColumnVisible(6,false);
                //tcm.setColumnVisible(7,false);
                tcm.setColumnWidth(1,300);
                //tcm.setDataCellRenderer(5, new qx.ui.table.cellrenderer.Boolean());

                this._table = table;
            },
            loadInvoiceList:function () {
                let invoices = new venditabant.sales.invoices.models.Invoices();
                invoices.loadInvoiceList(function(response) {
                    if(response.data !== null) {
                        let tableData = [];
                        for(let i = 0; i < response.data.length; i++) {
                            let open = response.data[i].open ? true : false;
                            tableData.push([
                                response.data[i].invoice_pkey,
                                response.data[i].customer,
                                response.data[i].invoiceno,
                                response.data[i].invoicedate,
                                response.data[i].paydate,
                                open,
                                response.data[i].customers_fkey,
                            ]);
                        }
                        this._table.getTableModel().setData(tableData);
                    }

                    //alert("Set table data here");
                }, this, this._open.getValue());
                //return ;//list;
            }
        }
    });