
qx.Class.define ( "venditabant.sales.invoices.views.Invoice",
    {
        extend: venditabant.application.base.views.Base,
        include:[qx.locale.MTranslation],
        construct: function () {
        },
        destruct: function () {
        },
        properties : {
            support : { nullable : true, check: "Boolean" },
            callback:{nullable:true},
            invoice_fkey: { nullable : true, check: "Number" },
        },
        members: {
            // Public functions ...
            __table : null,
            getView: function () {

                var page1 = new qx.ui.tabview.Page("Invoice");
                //page1.setLayout(new qx.ui.layout.VBox(4));
                page1.setLayout(new qx.ui.layout.Canvas());

                let lbl = this._createLbl(this.tr( "Customer" ), 70);
                page1.add ( lbl, { top: 10, left: 10 } );

                let customers = new venditabant.sales.customers.views.CustomersSelectBox().set({
                    width:150,
                    emptyrow:false,
                });
                this._customers = customers;
                page1.add ( customers.getView(), { top: 10, left: 90 } );

                lbl = this._createLbl(this.tr( "Invoice no" ),70);
                page1.add ( lbl, { top: 45, left: 10 } );

                let orderno = this._createTxt(
                    this.tr( "Invoice no" ),100,false,''
                );
                page1.add ( orderno, { top: 45, left: 90 } );
                this._orderno = orderno;

                let format = new qx.util.format.DateFormat("yyyy-MM-dd");

                lbl = new qx.ui.basic.Label ( this.tr( "Invoice date" )  );
                lbl.setRich ( true );
                lbl.setWidth( 70 );
                page1.add ( lbl, { top: 80, left: 10 } );

                let orderdate = new qx.ui.form.DateField ( );
                orderdate.setDateFormat(format);
                orderdate.setValue (new Date());
                orderdate.setWidth( 150 );

                page1.add ( orderdate, { top: 80, left: 90 } );
                this._orderdate = orderdate;

                lbl = new qx.ui.basic.Label ( ( "Pay date" )  );
                lbl.setRich ( true );
                lbl.setWidth( 90 );
                page1.add ( lbl, { top: 80, left: 250 } );

                var deliverydate = new qx.ui.form.DateField ( );
                deliverydate.setDateFormat(format);
                deliverydate.setValue (new Date(new Date().setFullYear(new Date().getFullYear() + 3)));
                deliverydate.setWidth( 150 );

                page1.add ( deliverydate, { top: 80, left: 350 } );
                this._deliverydate = deliverydate;

                let stockitems = new venditabant.stock.stockitems.views.StockitemsSelectBox().set({
                    width:180,
                    emptyrow:true,
                });
                let stockitemsview = stockitems.getView()
                this._stockitems = stockitems;
                page1.add ( stockitemsview, { top: 200, left: 110 } );

                let quantity = this._createTxt(
                    this.tr( "Quantity" ),100,true,this.tr("Quantity is required")
                );
                page1.add ( quantity, { top: 200, left: 300 } );
                this._quantity = quantity;

                let price = this._createTxt(
                    this.tr( "Price" ),100,true,this.tr("Price is required")
                );
                page1.add ( price, { top: 200, left: 410 } );
                this._price = price;

                let btnSignup = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 90, function ( ) {
                    this.saveOrderItem();
                }, this );
                page1.add ( btnSignup, { top: 200, left: 10 } );

                let btnCancel = this._createBtn ( this.tr ( "Cancel" ), "#FFAAAA70", 90, function ( ) {
                    this.getCallback().previousView();
                }, this );

                page1.add ( btnCancel, { top: 200, right: 10 } );

                let btnDone = this._createBtn ( this.tr ( "Done" ), "#FFAAAA70", 90, function ( ) {
                    this.getCallback().previousView();
                }, this );

                page1.add ( btnDone, { top: 200, right: 110 } );

                this._createTable();
                page1.add(this._table,{top:"42%", left:5, right:5,height:"57%"});

                return page1;
            },
            loadInvoice:function() {
                let that = this;
                if(this.getInvoiceFkey() !== null && this.getInvoiceFkey() > 0) {
                    let invoice = new venditabant.sales.invoices.models.Invoice();
                    invoice.loadInvoice(function(response){
                        that.loadInvoiceItems();
                        that._customers.setKey(response.data.customers_fkey);
                        that._orderno.setValue(response.data.orderno.toString());
                        that._deliverydate.setValue(new Date(response.data.deliverydate));
                        that._orderdate.setValue(new Date(response.data.orderdate));

                    },this, this.getInvoiceFkey());
                }
            },
            loadInvoiceItems:function() {
                let items = new venditabant.sales.invoices.models.InvoiceItems();

                if(this.getInvoiceFkey() !== null && this.getInvoiceFkey() > 0) {
                    items.loadInvoiceItemsList(function(response) {
                            let tableData = [];
                            if(response.data !== null) {
                                for(let i = 0; i < response.data.length; i++) {
                                    tableData.push([
                                        response.data[i].salesorder_items_pkey,
                                        response.data[i].stockitem,
                                        response.data[i].quantity,
                                        response.data[i].price,
                                        response.data[i].quantity * response.data[i].price,
                                        response.data[i].salesorders_fkey,
                                        response.data[i].stockitems_fkey,
                                    ]);
                                }
                            }

                            this._table.getTableModel().setData(tableData);
                        },
                        this,
                        this.getSalesorders_fkey()
                    );
                }

            },
            saveInvoiceItem:function() {
                let that = this;

                let stockitems_fkey = this._stockitems.getKey();
                let price  = this._price.getValue();
                let quantity = this._quantity.getValue();

                let data = {
                    stockitems_fkey: stockitems_fkey,
                    price: price,
                    quantity:quantity,
                    invoice_fkey:this.getInvoice_fkey(),
                }
                let model = new venditabant.sales.invoices.models.InvoiceItems();
                model.savevoiceItem(data, function(success) {
                    if ( success )  {
                        that.loadInvoiceItems();
                    }
                    else  {
                        alert ( this.tr ( 'Something went bad during saving of pricelist item' ) );
                    }
                }, this);
            },
            _createTable : function() {
                // Create the initial data
                let rowData =  '';
                let that = this;

                // table model
                var tableModel = new qx.ui.table.model.Simple();
                tableModel.setColumns(
                    [ "ID", "Stockitem", "Quantity", "Price", "Total", "salesorders_fkey", "stockitems_fkey" ]
                );
                tableModel.setData(rowData);
                //tableModel.setColumnEditable(1, true);
                //tableModel.setColumnEditable(2, true);
                //tableModel.setColumnSortable(3, false);

                // table
                var table = new qx.ui.table.Table(tableModel);

                table.set({
                    width: 800,
                    height: 200
                });

                table.getSelectionModel().setSelectionMode(qx.ui.table.selection.Model.SINGLE_SELECTION);
                table.getSelectionModel().addListener('changeSelection', function(e){
                    var selectionModel = e.getTarget();
                    var selectedRows = [];
                    selectionModel.iterateSelection(function(index) {
                        selectedRows.push(table.getTableModel().getRowData(index));
                    });

                    that._price.setValue(selectedRows[0][3]);
                    that._quantity.setValue(selectedRows[0][2]);
                    that._stockitems.setKey(selectedRows[0][6]);
                });
                let tcm = table.getTableColumnModel();
                tcm.setColumnVisible(0,false);
                tcm.setColumnVisible(5,false);
                tcm.setColumnVisible(6,false);
                tcm.setColumnWidth(1,300);
                tcm.setColumnWidth(2,200);
                tcm.setColumnWidth(3,200);

                this._table = table;
            },
            setInvoiceFkey:function(invoice_fkey) {
                this._invoice_fkey = invoice_fkey;
            },
            getInvoiceFkey:function() {
                return this._invoice_fkey;
            }
        }
    });
