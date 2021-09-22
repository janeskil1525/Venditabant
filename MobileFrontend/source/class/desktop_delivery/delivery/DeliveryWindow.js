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
        members  : {
            _buildDeliveryWindow:function() {
                var semi = new qx.ui.core.Widget ( );
                semi.set ( { opacity: 0.9, backgroundColor: "#404040" } );
                this.add ( semi, { top: 1, left: 1, right: 1, bottom: 1 } );

                var font = new qx.bom.Font ( 18, [ "Arial" ] );
                font.setBold ( true );

                font.setColor ( "#FFFFFF" );
                let colour = font.getColor();

                var lbl = new qx.ui.basic.Label ( "<center><b style='color: #FFFFFF'>" + this.tr ( "Delivery" ) + "</b></center>" );
                lbl.setFont ( font );
                lbl.setRich ( true );
                //lbl.setWidth( this.getWidth ( ) - 20  );
                this.add ( lbl, { top: 10, left: 10 } );

                this.customerList();
                this._createTable()
            },
            customerList : function() {
                let that = this;
                let cust = new desktop_delivery.models.Customers();
                var container = new qx.ui.container.Composite(new qx.ui.layout.VBox(2));
                var customers = new qx.ui.form.SelectBox();

                customers.addListener("changeSelection", function(evt) {
                    that._selectedCustomer = evt.getData()[0].getLabel();
                    /*if(this._list === null || typeof this._list === 'undefined') {
                        // recreate = false;
                    } else {
                        // recreate = true;
                    }*/
                    // this.loadStockitemList(this._selectedCustomer.item, recreate);
                }, this);

                cust.loadList(function(response) {
                    customers.add(new qx.ui.form.ListItem(""));
                    for(let i = 0; i < response.data.length; i++) {
                        let tempItem = new qx.ui.form.ListItem(response.data[i].customer);
                        customers.add(tempItem);
                    }

                }, this);

                var font = new qx.bom.Font ( 18, [ "Arial" ] );
                font.setColor ( "white" );
                font.setBold ( true );
                var lbl = new qx.ui.basic.Label ( this.tr ( "Select customer" ) );
                // var lbl = new qx.ui.basic.Label ( "<b style='color: #FFFFFF'>" + this.tr ( "Delivery" ) + "</b>" );
                lbl.setFont(font);
                lbl.setTextColor ( "#FFFFFF" );
                container.add(lbl);
                container.add(customers);
                this.add(container,{left : 20, top : 40});
            },
            _createTable : function() {
                // Create the initial data
                let rowData =  '';
                let that = this;

                // table model
                var tableModel = new qx.ui.table.model.Simple();
                tableModel.setColumns([ "ID", "Stockitem", "Quantity", "Price" ]);
                tableModel.setData(rowData);
                //tableModel.setColumnEditable(1, true);
                //tableModel.setColumnEditable(2, true);
                //tableModel.setColumnSortable(3, false);

                // table
                var table = new qx.ui.table.Table(tableModel);

                table.set({
                    width: 400,
                    height: 200
                });

                table.getSelectionModel().setSelectionMode(qx.ui.table.selection.Model.SINGLE_SELECTION);
                table.getSelectionModel().addListener('changeSelection', function(e){
                    var selectionModel = e.getTarget();
                   /* var selectedRows = [];
                    selectionModel.iterateSelection(function(index) {
                        selectedRows.push(table.getTableModel().getRowData(index));
                    });

                    that._customer.setValue(selectedRows[0][1]);
                    that._name.setValue(selectedRows[0][2]);
                    that._registrationnumber.setValue(selectedRows[0][4]);
                    that._homepage.setValue(selectedRows[0][6]);
                    that._phone.setValue(selectedRows[0][5]);
                    that._selectedPricelistHead = selectedRows[0][3];*/

                });
                var tcm = table.getTableColumnModel();

                tcm.setColumnWidth(0,20)
                // Display a checkbox in column 3
                //tcm.setDataCellRenderer(3, new qx.ui.table.cellrenderer.Boolean());

                // use a different header renderer
                //tcm.setHeaderCellRenderer(2, new qx.ui.table.headerrenderer.Icon("icon/16/apps/office-calendar.png", "A date"));

                this._table = table;
                this.add(table,{top:150, left:10});
                return ;
            },
        }
    });