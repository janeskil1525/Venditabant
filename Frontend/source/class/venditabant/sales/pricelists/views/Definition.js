
qx.Class.define ( "venditabant.sales.pricelists.views.Definition",
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
            _selectedPricelistHead : null,
            setParams: function (params) {
            },
            _buildWindow: function () {
                var win = new qx.ui.window.Window("Pricelists", "icon/16/apps/internet-feed-reader.png");
                win.setLayout(new qx.ui.layout.VBox(10));
                win.setStatus("Application is ready");
                /*win.setWidth(800);
                win.setHeight(500);*/
                win.setCenterOnAppear(true);
                win.open();
                let app = qx.core.Init.getApplication();
                let root = app.getRoot();
                root.add(win, {left: 350, top: 120});

                var atom = new qx.ui.basic.Atom("Manage pricelists", "icon/22/apps/utilities-calculator.png");
                win.add(atom);
                win.setShowStatusbar(true);

                var tabView = new qx.ui.tabview.TabView();
                tabView.setWidth(800);
                tabView.setHeight(300);
                win.add(tabView, {flex:1});

                var page1 = new qx.ui.tabview.Page("Definition");
                //page1.setLayout(new qx.ui.layout.VBox(4));
                page1.setLayout(new qx.ui.layout.Canvas());

                let pricelists = new qx.ui.form.SelectBox();

                pricelists.addListener("changeSelection", function(e) {
                    let selection = e.getData()[0].getLabel();

                    this._selectedPricelistHead = selection;

                    /*this.debug("Selected item: " + selection);
                    alert("Selected item: " + selection);*/
                },this);
                this._pricelists = pricelists;
                this.loadPricelists();

                page1.add ( pricelists, { top: 30, left: 10 } );

                let btnAddPricelist = this._createBtn ( this.tr ( "Add" ), "rgba(239,170,255,0.44)", 70, function ( ) {
                    this.addPricelist ( );
                }, this );

                page1.add ( btnAddPricelist, { top: 30, left: 140 } );

                let lbl = new qx.ui.basic.Label ( this.tr( "Stockitem" )  );
                lbl.setRich ( true );
                lbl.setWidth( 70 );
                page1.add ( lbl, { top: 80, left: 10 } );

                let stockitems = new qx.ui.form.SelectBox();
                stockitems.setWidth( 150 );
                stockitems.addListener("changeSelection", function(e) {
                    let selection = e.getData()[0].getLabel();
                    this._selectedStockitem = selection;
                },this);
                this._stockitems = stockitems;
                this.loadStockitems();

                page1.add ( stockitems, { top: 80, left: 90 } );

                /*var stockitem = new qx.ui.form.TextField ( );
                stockitem.setPlaceholder (  ( "Stockitem" ) );
                stockitem.setWidth( 150 );

                page1.add ( stockitem, { top: 80, left: 90 } );
                this._stockitem = stockitem;*/

                lbl = new qx.ui.basic.Label ( ( "Price" )  );
                lbl.setRich ( true );
                lbl.setWidth( 70 );
                page1.add ( lbl, { top: 80, left: 250 } );

                var price = new qx.ui.form.TextField ( );
                price.setPlaceholder (  ( "Price" ) );
                price.setWidth( 150 );

                page1.add ( price, { top: 80, left: 350 } );
                this._price = price;

                var format = new qx.util.format.DateFormat("yyyy-MM-dd");

                lbl = new qx.ui.basic.Label ( this.tr( "From" )  );
                lbl.setRich ( true );
                lbl.setWidth( 70 );
                page1.add ( lbl, { top: 120, left: 10 } );

                var from = new qx.ui.form.DateField ( );
                from.setDateFormat(format);
                from.setValue (new Date());
                from.setWidth( 150 );

                page1.add ( from, { top: 120, left: 90 } );
                this._from = from;

                lbl = new qx.ui.basic.Label ( ( "To" )  );
                lbl.setRich ( true );
                lbl.setWidth( 70 );
                page1.add ( lbl, { top: 120, left: 250 } );

                var to = new qx.ui.form.DateField ( );
                to.setDateFormat(format);
                to.setValue (new Date(new Date().setFullYear(new Date().getFullYear() + 3)));
                to.setWidth( 150 );

                page1.add ( to, { top: 120, left: 350 } );
                this._to = to;

                let btnSignup = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 135, function ( ) {
                    this.savePricelistItem ( );
                }, this );
                page1.add ( btnSignup, { bottom: 10, left: 10 } );

                let btnCancel = this._createBtn ( this.tr ( "Cancel" ), "#FFAAAA70", 135, function ( ) {
                    this.cancel ( );
                }, this );
                page1.add ( btnCancel, { bottom: 10, right: 10 } );
                tabView.add(page1);

                this._createTable();
                win.add(this._table);
                this.loadPricelistItems();
            },
            loadPricelistItems:function() {
                let pricelistitems = new venditabant.sales.pricelists.models.PricelistItems();

                let pricelisthead = 'DEFAULT'
                if(typeof this._selectedPricelistHead !== 'undefined' && this._selectedPricelistHead !== null){
                    pricelisthead = this._selectedPricelistHead;
                }

                pricelistitems.loadList(function(response) {
                        let tableData = [];
                        if(response.data !== null) {
                            for(let i = 0; i < response.data.length; i++) {
                                tableData.push([
                                    response.data[i].pricelist_items_pkey,
                                    response.data[i].stockitem,
                                    response.data[i].price,
                                    response.data[i].fromdate,
                                    response.data[i].todate,
                                ]);
                            }
                        }

                        this._table.getTableModel().setData(tableData);
                    },
                    this,
                    pricelisthead
                );
            },
            loadStockitems:function () {
                let stockitems = new venditabant.stock.stockitems.models.Stockitem();
                stockitems.loadList(function(response, rsp) {
                    let tableData = [];
                    for(let i = 0; i < response.data.length; i++) {
                        this.addStockitemsToList(response.data[i].stockitem);
                    }
                }, this);
            },
            addStockitemsToList:function(stockitem) {
                let tempItem = new qx.ui.form.ListItem(stockitem);
                this._stockitems.add(tempItem);
            },
            addPricelist : function() {
                let win = new venditabant.sales.pricelists.views.NewHead(this);

            },
            loadPricelists : function() {
                let that = this;
                let pricelist_heads = new venditabant.sales.pricelists.models.Pricelists();

                pricelist_heads.loadList(function(response){
                    if(response.data !== null) {
                        for(let i= 0; i < response.data.length ;i++) {
                            let pricelist = response.data[i].pricelist;
                            that.addPricelistHead(pricelist);
                        }
                    }
                }, this);
            },
            addPricelistHead:function(pricelist) {
                let tempItem = new qx.ui.form.ListItem(pricelist);
                this._pricelists.add(tempItem);
                if(pricelist === 'DEFAULT'){
                    this._selectedPricelistHead = 'DEFAULT';
                    this._pricelists.setSelection([tempItem]);
                }
            },
            savePricelistItem:function() {
                let that = this;
                let pricelist = this._selectedPricelistHead;
                let stockitem = this._selectedStockitem;
                let price  = this._price.getValue();
                let from = this._from.getValue();
                let to = this._to.getValue();

                let data = {
                    pricelist: pricelist,
                    stockitem: stockitem,
                    price: price,
                    fromdate:from,
                    todate:to,
                }
                let model = new venditabant.sales.pricelists.models.PricelistItems();
                model.savePricelistItem(data, function(success) {
                    if ( success )  {
                        that.loadPricelistItems();
                    }
                    else  {
                        alert ( this.tr ( 'Something went bad during saving of pricelist item' ) );
                    }
                }, this);
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
                tableModel.setColumns([ "ID", "Stockitem", "Price", "From", "To" ]);
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

                    /*that._stockitem.setValue(selectedRows[0][1]);
                    that._description.setValue(selectedRows[0][2]);*/
                });
                var tcm = table.getTableColumnModel();

                // Display a checkbox in column 3
                //tcm.setDataCellRenderer(3, new qx.ui.table.cellrenderer.Boolean());

                // use a different header renderer
                //tcm.setHeaderCellRenderer(2, new qx.ui.table.headerrenderer.Icon("icon/16/apps/office-calendar.png", "A date"));

                this._table = table;

                return ;
            },
        }
    });