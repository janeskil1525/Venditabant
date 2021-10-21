
qx.Class.define ( "venditabant.stock.warehouse.views.Definition",
    {
        extend: venditabant.application.base.views.Base,
        include:[qx.locale.MTranslation],
        construct: function () {
        },
        destruct: function () {
        },
        properties : {
            support : { nullable : true, check: "Boolean"}
        },
        members: {
            // Public functions ...
            __table : null,
            _address: new venditabant.application.Const().venditabant_endpoint(),
            setParams: function (params) {
            },
            getView: function () {
                let view = new qx.ui.container.Composite(new qx.ui.layout.Canvas());
                view.setBackgroundColor("white");
                // Add a TabView
                var tabView = new qx.ui.tabview.TabView();
                view.add(tabView, {top: 0, left: 5, right: 5, height: "50%"});

                var page1 = new qx.ui.tabview.Page("Definition");
                //page1.setLayout(new qx.ui.layout.VBox(4));
                page1.setLayout(new qx.ui.layout.Canvas());

                let lbl = this._createLbl(this.tr( "Warehouse" ),70);
                page1.add ( lbl, { top: 10, left: 10 } );

                let warehouse = this._createTxt(
                    this.tr( "Warehouse" ),150,true,this.tr("Warehouse is required")
                );

                page1.add ( warehouse, { top: 10, left: 90 } );
                this._warehouse = warehouse;

                lbl = this._createLbl(this.tr( "Description" ),70);
                page1.add ( lbl, { top: 10, left: 250 } );

                let descriptn = this._createTxt(
                    this.tr( "Description" ),250,true,this.tr("Description is required")
                );
                page1.add ( descriptn, { top: 10, left: 350 } );
                this._description = descriptn;

                let btnSignup = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 135, function ( ) {
                    this.saveWarehouse ( );
                }, this );
                page1.add ( btnSignup, { bottom: 10, left: 10 } );

                let btnCancel = this._createBtn ( this.tr ( "Cancel" ), "#FFAAAA70", 135, function ( ) {
                    this.clearScreen ( );
                }, this );
                page1.add ( btnCancel, { bottom: 10, right: 10 } )
                tabView.add(page1);
                this._createTable();

                view.add(this._table,{top:"52%", left:5, right:5,height:"45%"});

                this.loadWarehouses();
                return view;
            },
            saveWarehouse:function() {
                let warehouse = this._warehouse.getValue();
                let description  = this._description.getValue();

                let data = {
                    warehouse: warehouse,
                    warehouse_name: description,
                }
                let com = new venditabant.stock.warehouse.models.Warehouse ( );
                com.saveWarehouse (function ( success ) {
                    if ( success )  {
                        this.loadWarehouses();
                        this.clearScreen();
                    }
                    else  {
                        alert ( this.tr ( 'Something went wront with the save, please try again' ) );
                    }
                }, this, data );
            },
            clearScreen:function() {
                this._warehouse.setValue('');
                this._description.setValue('');
            },
            _createTable : function() {
                // Create the initial data
                let rowData =  '';
                let that = this;

                // table model
                var tableModel = new qx.ui.table.model.Simple();
                tableModel.setColumns([
                    "ID", "Warehouse", "Description" ]);
                tableModel.setData(rowData);
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
                    that._warehouse.setValue(selectedRows[0][1]);
                    that._description.setValue(selectedRows[0][2]);

                });
                var tcm = table.getTableColumnModel();
                tcm.setColumnVisible(0,false);
                tcm.setColumnWidth(1,300);
                tcm.setColumnWidth(2,800);
                // Display a checkbox in column 3

                // use a different header renderer
                //tcm.setHeaderCellRenderer(2, new qx.ui.table.headerrenderer.Icon("icon/16/apps/office-calendar.png", "A date"));

                this._table = table;

                return ;
            },
            loadWarehouses:function () {
                let warehouse = new venditabant.stock.warehouse.models.Warehouse();
                warehouse.loadList(function(response) {
                    let tableData = [];
                    if(response.data !== null){
                        for(let i = 0; i < response.data.length; i++) {
                            tableData.push([
                                response.data[i].warehouses_pkey,
                                response.data[i].warehouse,
                                response.data[i].warehouse_name,
                            ]);
                        }
                        this._table.getTableModel().setData(tableData);
                    }
                }, this);
            },
        }
    });
