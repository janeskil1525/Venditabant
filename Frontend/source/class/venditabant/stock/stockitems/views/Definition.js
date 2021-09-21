
qx.Class.define ( "venditabant.stock.stockitems.views.Definition",
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
            __table : null,
            setParams: function (params) {
            },
            _buildWindow: function () {
                var win = new qx.ui.window.Window("Stockitems", "icon/16/apps/internet-feed-reader.png");
                win.setLayout(new qx.ui.layout.VBox(10));
                win.setStatus("Application is ready");
                win.open();
                let app = qx.core.Init.getApplication();
                let root = app.getRoot();
                root.add(win, {left: 350, top: 120});

                var atom = new qx.ui.basic.Atom("Manage stockitems", "icon/22/apps/utilities-calculator.png");
                win.add(atom);
                win.setShowStatusbar(true);

                /*var box = new qx.ui.container.Composite();
                box.setLayout(new qx.ui.layout.HBox(10));
                win.add(box, {flex: 1});*/

                // Add a TabView
                var tabView = new qx.ui.tabview.TabView();
                tabView.setWidth(800);
                tabView.setHeight(300);
                win.add(tabView, {flex:1});

                var page1 = new qx.ui.tabview.Page("Definition");
                //page1.setLayout(new qx.ui.layout.VBox(4));
                page1.setLayout(new qx.ui.layout.Canvas());

                var lbl = new qx.ui.basic.Label ( ( "Stockitem" )  );
                lbl.setRich ( true );
                lbl.setWidth( 70 );
                page1.add ( lbl, { top: 10, left: 10 } );

                var stockitem = new qx.ui.form.TextField ( );
                stockitem.setPlaceholder (  ( "Stockitem" ) );
                stockitem.setWidth( 150 );
                stockitem.setRequired(true);
                stockitem.setRequiredInvalidMessage(this.tr("Stockitem is required"));

                page1.add ( stockitem, { top: 10, left: 90 } );
                this._stockitem = stockitem;

                lbl = new qx.ui.basic.Label ( ( "Description" )  );
                lbl.setRich ( true );
                lbl.setWidth( 70 );
                page1.add ( lbl, { top: 10, left: 250 } );

                var descriptn = new qx.ui.form.TextField ( );
                descriptn.setPlaceholder (  ( "Description" ) );
                descriptn.setWidth( 250 );

                page1.add ( descriptn, { top: 10, left: 350 } );
                this._description = descriptn;

                let btnSignup = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 135, function ( ) {
                    this.saveStockitem ( );
                }, this );
                page1.add ( btnSignup, { bottom: 10, left: 10 } );

                let btnCancel = this._createBtn ( this.tr ( "Cancel" ), "#FFAAAA70", 135, function ( ) {
                    this.cancel ( );
                }, this );
                page1.add ( btnCancel, { bottom: 10, right: 10 } );

                tabView.add(page1);

                /*var page2 = new qx.ui.tabview.Page("Page 2");
                tabView.add(page2);

                var page3 = new qx.ui.tabview.Page("Page 3");
                tabView.add(page3);*/
                this._createTable();
                win.add(this._table);

                this.loadStockitems();
            },
            saveStockitem:function() {
                let stockitem = this._stockitem.getValue();
                let description  = this._description.getValue();
                let data = {
                    stockitem: stockitem,
                    description: description
                }
                let com = new venditabant.communication.Post ( );
                com.send ( "http://192.168.1.134/", "api/v1/stockitem/save/", data, function ( success ) {
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
            _createTable : function() {
                // Create the initial data
                let rowData =  '';
                let that = this;

                // table model
                var tableModel = new qx.ui.table.model.Simple();
                tableModel.setColumns([ "ID", "Stockitem", "Description" ]);
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

                    that._stockitem.setValue(selectedRows[0][1]);
                    that._description.setValue(selectedRows[0][2]);
                });
                var tcm = table.getTableColumnModel();

                // Display a checkbox in column 3
                //tcm.setDataCellRenderer(3, new qx.ui.table.cellrenderer.Boolean());

                // use a different header renderer
                //tcm.setHeaderCellRenderer(2, new qx.ui.table.headerrenderer.Icon("icon/16/apps/office-calendar.png", "A date"));

                this._table = table;

                return ;
            },
            loadStockitems:function () {
                let stockitems = new venditabant.stock.stockitems.models.Stockitem();
                stockitems.loadList(function(response) {
                    let tableData = [];
                    for(let i = 0; i < response.data.length; i++) {

                        tableData.push([
                            response.data[i].stockitems_pkey,
                            response.data[i].stockitem,
                            response.data[i].description]);
                    }
                    this._table.getTableModel().setData(tableData);
                    //alert("Set table data here");
                }, this);
                //return ;//list;
            }
        }
    });
