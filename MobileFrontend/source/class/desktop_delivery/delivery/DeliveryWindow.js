qx.Class.define ( "desktop_delivery.delivery.DeliveryWindow",
    {
        extend: qx.ui.container.Composite,
        construct: function () {
            this.base(arguments);
            this.setLayout(new qx.ui.layout.Canvas());
            this.set({
                width: 300,
                height: 200
            });
            this._buildDeliveryWindow();

            var top = parseInt((qx.bom.Document.getHeight() - 200) / 2, 10);
            var left = parseInt((qx.bom.Document.getWidth() - 300) / 2, 10);
            var app = qx.core.Init.getApplication();
            var root = app.getRoot();
            root.add(this, {edge: 0});
        },
        destruct : function ( )  {

        },
        properties: {
            customer_addresses_fkey: {nullable:true, check:"Number"},
        },
        members  : {
            _buildDeliveryWindow:function() {
                let semi = new qx.ui.core.Widget ( );
                semi.set ( { opacity: 0.9, backgroundColor: "#404040" } );
                this.add ( semi, { top: 1, left: 1, right: 1, bottom: 1 } );

                let font = new qx.bom.Font ( 18, [ "Arial" ] );
                font.setBold ( true );

                let lbl = new qx.ui.basic.Label ( "<center><b style='color: #FFFFFF'>" + this.tr ( "Delivery" ) + "</b></center>" );
                lbl.setFont ( font );
                lbl.setRich ( true );
                //lbl.setWidth( this.getWidth ( ) - 20  );
                this.add ( lbl, { top: 10, left: 10 } );
                this._createLogoutButton();
                this.customerList();
                this._createAddButton();
                this._createQuantityField();
                this._createStockitemLabel();
                this._createTable();
                this._createSaveButton();
            },
            setCustomerAddressFkey:function(customer_addresses_fkey) {
                this.setCustomer_addresses_fkey(customer_addresses_fkey);
            },
            _createLogoutButton:function() {
                let that = this;
                let logout = this._createBtn ( this.tr ( "Logout" ), "rgba(239,170,255,0.44)", 80, function ( ) {
                    let jwt = new qx.data.store.Offline('userid','local');
                    jwt.setModel('');
                    let win = new desktop_delivery.users.login.LoginWindow ( );
                    win.show ( );
                    that.destroy();
                }, this );
                this.add ( logout, { top:18, left: 330 } );
            },
            _createSaveButton:function(){
                let save = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 400, function ( ) {
                    this.saveSalesorder ( );
                }, this );
                this.add ( save, { top:570, left: 10 } );
            },
            saveSalesorder:function() {

                if(this._selectedCustomer === null || this._selectedCustomer === ''){
                    return;
                }

                let data = {
                    customer:this._selectedCustomer,
                };

                let sales = new desktop_delivery.models.Salesorders();
                sales.close(function(success) {
                    if (success) {
                        this.loadStockitemList(this._selectedCustomer, true);
                    } else {
                        alert(this.tr("Could not save order, please try again"));
                    }
                }, this, data);

            },
            _createStockitemLabel: function(){
                let lbl = this._createLbl(this.tr( "No stockitem selected ..." ), 200);
                lbl.setTextColor ( "#FFFFFF" );
                let font = new qx.bom.Font ( 16, [ "Arial" ] );
                // font.setBold ( true );
                lbl.setFont ( font );
                this._selectedStockitem = lbl;
                this.add ( lbl, { top: 100, left: 10 } );
            },
            _createQuantityField:function(){
                let quantity = this._createTxt(this.tr("Quantity"), 70, false);
                this.add ( quantity, { top: 100, left: 250 } );
                this._quantity = quantity
            },
            saveSalesorderItem:function(){
                if(this._selectedCustomer !== '') {
                    let stockitem = this._selectedStockitem.getValue();
                    //let stockitem = stock.substring(0,stock.indexOf(' - '));

                    let data = {
                        customer_addresses_pkey:this.getCustomer_addresses_pkey(),
                        quantity:this._quantity.getValue(),
                        stockitem:stockitem,
                        price:10
                    };

                    let sales = new desktop_delivery.models.Salesorders();
                    sales.add(function(success) {
                        if (success) {
                            this._quantity.setValue('0');
                            this._selectedStockitem.setValue('No stockitem selected');
                            this.loadStockitemList(this._selectedCustomer, true);
                        } else {
                            alert(this.tr("Could not save item, please try again"));
                        }
                    }, this, data);
                }
            },
            _createAddButton:function(){
                let add = this._createBtn ( this.tr ( "Add" ), "rgba(239,170,255,0.44)", 80, function ( ) {
                    this.saveSalesorderItem ( );
                }, this );
                this.add ( add, { top:100, left: 330 } );
            },
            loadStockitemList : function(customer, recreate) {
                let that = this;
                let stock = new desktop_delivery.models.Stockitems();
                let tableData = [];
                stock.loadListSales(function(response) {
                    let groupCount = response.data.salesorders.length;
                    for(let i = 0; i < response.data.salesorders.length; i++) {
                        tableData.push([
                            response.data.salesorders[i].stockitems_pkey,
                            response.data.salesorders[i].stockitem,
                            response.data.salesorders[i].quantity,
                            response.data.salesorders[i].price,
                            "Salesorders",
                        ]);
                    }
                    groupCount += response.data.history.length;
                    for(let i = 0; i < response.data.history.length; i++) {
                        tableData.push([
                            response.data.history[i].stockitems_pkey,
                            response.data.history[i].stockitem,
                            response.data.history[i].quantity,
                            response.data.history[i].price,
                            "History",
                        ]);
                    }
                    groupCount += response.data.stockitems.length;
                    for(let i = 0; i < response.data.stockitems.length; i++) {
                        tableData.push([
                            response.data.stockitems[i].stockitems_pkey,
                            response.data.stockitems[i].stockitem,
                            response.data.stockitems[i].quantity,
                            response.data.stockitems[i].price,
                            "Stockitems"
                        ]);
                    }
                    if(recreate === true) {
                        // that.recreateUIList(data);
                    } else {
                        // that.createUiList(data);
                        // that.addSaveButton();
                    }
                    this._table.getTableModel().setData(tableData);
                }, this, customer);

            },
            _createTable : function() {
                // Create the initial data
                let rowData =  '';
                let that = this;

                // table model
                var tableModel = new qx.ui.table.model.Simple();
                tableModel.setColumns([ "ID", "Stockitem", "Quantity", "Price", "Type" ]);
                tableModel.setData(rowData);
                // tableModel.sortByColumn()
                //tableModel.setColumnEditable(1, true);
                //tableModel.setColumnEditable(2, true);
                //tableModel.setColumnSortable(3, false);

                // table
                var table = new qx.ui.table.Table(tableModel);

                table.set({
                    width: 400,
                    height: 400,
                    rowHeight:30
                });

                table.getSelectionModel().setSelectionMode(qx.ui.table.selection.Model.SINGLE_SELECTION);
                table.getSelectionModel().addListener('changeSelection', function(e){
                    var selectionModel = e.getTarget();
                    var selectedRows = [];
                    selectionModel.iterateSelection(function(index) {
                        selectedRows.push(table.getTableModel().getRowData(index));
                    });
                    that._selectedStockitem.setValue(selectedRows[0][1]);
                    let quantity = selectedRows[0][2] ? selectedRows[0][2] : "0";
                    that._quantity.setValue(quantity);
                });
                let tcm = table.getTableColumnModel();

                tcm.setColumnWidth(0,50);
                tcm.setColumnWidth(1,150);
                tcm.setColumnWidth(2,50);
                tcm.setColumnWidth(3,50);
                // Display a checkbox in column 3
                //tcm.setDataCellRenderer(3, new qx.ui.table.cellrenderer.Boolean());

                // use a different header renderer
                //tcm.setHeaderCellRenderer(2, new qx.ui.table.headerrenderer.Icon("icon/16/apps/office-calendar.png", "A date"));

                this._table = table;
                this.add(table,{top:150, left:10});
            },
            _createBtn : function (txt, clr, width, cb, ctx) {
                let btn = new desktop_delivery.widget.button.Standard().createBtn(txt, clr, width, cb, ctx)

                return btn;
            },
            _createTxt:function(placeholder, width, required, requiredTxt) {
                let txt = new desktop_delivery.widget.textfield.Standard().createTxt(placeholder, width, required, requiredTxt);
                return txt;
            },
            _createLbl:function(label, width, required, requiredTxt) {
                let lbl = new desktop_delivery.widget.label.Standard().createLbl(label, width, required, requiredTxt);
                return lbl;
            }
        }
    });