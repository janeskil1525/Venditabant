
qx.Class.define ( "venditabant.sales.pricelists.views.Definition",
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
            __table : null,
            _selectedPricelistHead : null,
            setParams: function (params) {
            },
            getView: function () {
                let view = new qx.ui.container.Composite(new qx.ui.layout.Canvas());

                var tabView = new qx.ui.tabview.TabView();
                view.add(tabView, {top: 0, left: 5, right: 5, height: "50%"});

                var page1 = new qx.ui.tabview.Page("Definition");
                //page1.setLayout(new qx.ui.layout.VBox(4));
                page1.setLayout(new qx.ui.layout.Canvas());

                let pricelists = new venditabant.sales.pricelists.views.PricelistsSelectBox().set({
                    width:180,
                    emptyrow:false,
                    callback:this,
                    tooltip:this.tr( "Select pricelist" ),
                });
                this._pricelists = pricelists;
                page1.add ( pricelists.getView(), { top: 30, left: 10 } );

                let btnAddPricelist = this._createBtn ( this.tr ( "Add" ), "rgba(239,170,255,0.44)", 70, function ( ) {
                    this.addPricelist ( );
                }, this, this.tr( "Create a new pricelist" ) );

                page1.add ( btnAddPricelist, { top: 30, left: 200 } );

                let lbl = new qx.ui.basic.Label ( this.tr( "Stockitem" )  );
                lbl.setRich ( true );
                lbl.setWidth( 70 );
                page1.add ( lbl, { top: 80, left: 10 } );

                let stockitems = new venditabant.stock.stockitems.views.StockitemsSelectBox().set({
                    width:180,
                    emptyrow:true,
                    tooltip:this.tr( "Select stockitem" ),
                });
                let stockitemsview = stockitems.getView()
                this._stockitems = stockitems;
                page1.add ( stockitemsview, { top: 80, left: 90 } );

                lbl = new qx.ui.basic.Label ( ( "Price" )  );
                lbl.setRich ( true );
                lbl.setWidth( 70 );
                page1.add ( lbl, { top: 80, left: 350 } );

                var price = new qx.ui.form.TextField ( );
                price.setToolTipText(this.tr( "Set customer gross price" ));
                price.setPlaceholder (  ( "Price" ) );
                price.setWidth( 150 );

                page1.add ( price, { top: 80, left: 450 } );
                this._price = price;
                this._price.setValue('0.00');

                var format = new qx.util.format.DateFormat("yyyy-MM-dd");

                lbl = new qx.ui.basic.Label ( this.tr( "From" )  );
                lbl.setRich ( true );
                lbl.setWidth( 70 );
                page1.add ( lbl, { top: 120, left: 10 } );

                var from = new qx.ui.form.DateField ( );
                from.setToolTipText(this.tr( "Set from what date this price will be valid" ));
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
                to.setToolTipText(this.tr( "Set the too date this price will be valid" ));
                to.setDateFormat(format);
                to.setValue (new Date(new Date().setFullYear(new Date().getFullYear() + 3)));
                to.setWidth( 150 );

                page1.add ( to, { top: 120, left: 350 } );
                this._to = to;

                let btnSave = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 135, function ( ) {
                    this.savePricelistItem();
                    this.loadPricelistItems();
                }, this, this.tr( "Save price record" ) );
                page1.add ( btnSave, { bottom: 10, left: 10 } );

                let btnNew = this._createBtn ( this.tr ( "New" ), "#FFAAAA70", 135, function ( ) {
                    this.newItem ( );
                }, this, this.tr( "Create a new price record for the selected pricelist" ) );
                page1.add ( btnNew, { bottom: 10, right: 10 } );
                tabView.add(page1);

                this._createTable();
                view.add(this._table,{top:"52%", left:5, right:5,height:"45%"});

                return view;
            },
            newItem:function() {
                this._to.setValue (new Date(new Date().setFullYear(new Date().getFullYear() + 3)));
                this._from.setValue (new Date());
                this._price.setValue('0.00');
            },
            loadPricelistItems:function() {
                let pricelistitems = new venditabant.sales.pricelists.models.PricelistItems();

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
                                    response.data[i].stockitems_fkey
                                ]);
                            }
                        }

                        this._table.getTableModel().setData(tableData);
                    },
                    this,
                    this._pricelists.getKey()
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
            setSelectedPricelistHead:function(pricelist) {
                this._selectedPricelistHead = pricelist;
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
                let pricelists_fkey = this._pricelists.getKey();
                let stockitems_fkey = this._stockitems.getKey();
                let price  = this._price.getValue();
                let from = this._from.getValue();
                let to = this._to.getValue();
                let pricelist = this._pricelists.getPricelist();
                let stockitem = this._stockitems.getStockitem();

                let data = {
                    pricelists_fkey: pricelists_fkey,
                    stockitems_fkey: stockitems_fkey,
                    price: price,
                    fromdate:from,
                    todate:to,
                    pricelist:pricelist,
                    stockitem:stockitem,
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
            _createTable : function() {
                // Create the initial data
                let rowData =  '';
                let that = this;

                // table model
                var tableModel = new qx.ui.table.model.Simple();
                tableModel.setColumns([ "ID", "Stockitem", "Price", "From", "To", "stockitems_fkey" ]);
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

                    that._price.setValue(selectedRows[0][2]);
                    let from_date = new Date(selectedRows[0][3]);
                    that._from.setValue(from_date);
                    let to_date = new Date(selectedRows[0][4]);
                    that._to.setValue(to_date);
                    that._stockitems.setKey(selectedRows[0][5]);
                });
                var tcm = table.getTableColumnModel();
                tcm.setColumnVisible(0,false);
                tcm.setColumnVisible(5,false);
                tcm.setColumnWidth(1,300);
                tcm.setColumnWidth(3,300);
                tcm.setColumnWidth(4,300);

                this._table = table;

                return ;
            },
        }
    });
