
qx.Class.define ( "venditabant.stock.stockitems.views.Definition",
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
                // Add a TabView
                var tabView = new qx.ui.tabview.TabView();
                view.add(tabView, {top: 0, left: 5, right: 5, height: "50%"});

                var page1 = new qx.ui.tabview.Page("Definition");
                //page1.setLayout(new qx.ui.layout.VBox(4));
                page1.setLayout(new qx.ui.layout.Canvas());

                let lbl = this._createLbl(this.tr( "Stockitem" ),70);
                page1.add ( lbl, { top: 10, left: 10 } );

                let stockitem = this._createTxt(
                    this.tr( "Stockitem" ),150,true,this.tr("Stockitem is required")
                );

                page1.add ( stockitem, { top: 10, left: 90 } );
                this._stockitem = stockitem;

                lbl = this._createLbl(this.tr( "Description" ),70);
                page1.add ( lbl, { top: 10, left: 250 } );

                let descriptn = this._createTxt(
                    this.tr( "Description" ),250,true,this.tr("Description is required")
                );
                page1.add ( descriptn, { top: 10, left: 350 } );
                this._description = descriptn;

                let productgroups = new qx.ui.form.SelectBox();
                productgroups.setWidth( 180 );
                productgroups.addListener("changeSelection", function(e) {
                    let selection = e.getData()[0].getLabel();
                    this._selectedProductgroup = selection;
                },this);
                this._productgroups = productgroups;
                this.loadProductgroups();

                page1.add ( productgroups, { top: 10, left: 630 } );

                lbl = this._createLbl(this.tr( "Price" ),70);
                page1.add ( lbl, { top: 50, left: 10 } );

                let price = this._createTxt(
                    this.tr( "Price" ),80,false
                );

                page1.add ( price, { top: 50, left: 90 } );
                this._price = price;

                lbl = this._createLbl(this.tr( "PO price" ),70);
                page1.add ( lbl, { top: 50, left: 250 } );

                let purchprice = this._createTxt(
                    this.tr( "Purchase price" ),80,false
                );

                page1.add ( purchprice, { top: 50, left: 350 } );
                this._purchaseprice = purchprice;

                let vat = new qx.ui.form.SelectBox();
                vat.setWidth( 180 );
                vat.addListener("changeSelection", function(e) {
                    let selection = e.getData()[0].getLabel();
                    this._selectedVat = selection;
                },this);
                this._vat = vat;
                this.loadVat();
                page1.add ( vat, { top: 50, left: 630 } );

                lbl = this._createLbl(this.tr( "Active" ),70);
                page1.add ( lbl, { top: 90, left: 10 } );

                let active = new qx.ui.form.CheckBox("");
                page1.add ( active, { top: 90, left: 90 } );
                this._active = active;

                lbl = this._createLbl(this.tr( "Stocked" ),70);
                page1.add ( lbl, { top: 90, left: 250 } );

                let stocked = new qx.ui.form.CheckBox("");
                page1.add ( stocked, { top: 90, left: 350 } );
                this._stocked = stocked;

                let btnSignup = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 135, function ( ) {
                    this.saveStockitem ( );
                }, this );
                page1.add ( btnSignup, { bottom: 10, left: 10 } );

                let btnCancel = this._createBtn ( this.tr ( "Cancel" ), "#FFAAAA70", 135, function ( ) {
                    this.cancel ( );
                }, this );
                page1.add ( btnCancel, { bottom: 10, right: 10 } )
                tabView.add(page1);
                this._createTable();

                view.add(this._table,{top:"52%", left:5, right:5,height:"45%"});

                this.loadStockitems();
                return view;
            },
            loadVat:function() {
                let get = new venditabant.settings.models.Settings();
                get.loadList(function(response) {
                    var item;
                    for (let i=0; i < response.data.length; i++) {
                        let row = response.data[i].param_value + ' ' + response.data[i].param_description;
                        item = new qx.ui.form.ListItem(row, null);
                        this._vat.add(item);
                    }
                },this,'VAT');
            },
            loadProductgroups:function() {
                let get = new venditabant.settings.models.Settings();
                get.loadList(function(response) {
                    var item;
                    for (let i=0; i < response.data.length; i++) {
                        let row = response.data[i].param_value + ' ' + response.data[i].param_description;
                        item = new qx.ui.form.ListItem(row, null);
                        this._productgroups.add(item);
                    }
                },this,'PRODUCTGROUPS');
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
                tableModel.setColumns([ "ID", "Stockitem", "Description", "Price","Purchase Price","Active", "Stocked" ]);
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
                    that._price.setValue(selectedRows[0][3]);
                    that._purchaseprice.setValue(selectedRows[0][4]);

                    let active = selectedRows[0][5] ? true : false;
                    let stocked = selectedRows[0][6] ? true : false;

                    that._active.setValue(active);
                    that._stocked.setValue(stocked);
                });
                var tcm = table.getTableColumnModel();

                // Display a checkbox in column 3
                tcm.setDataCellRenderer(5, new qx.ui.table.cellrenderer.Boolean());
                tcm.setDataCellRenderer(6, new qx.ui.table.cellrenderer.Boolean());

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
            _createTxt:function(placeholder, width, required, requiredTxt) {
                let txt = new venditabant.widget.textfield.Standard().createTxt(placeholder, width, required, requiredTxt);
                return txt;
            },
            _createLbl:function(label, width, required, requiredTxt) {
                let lbl = new venditabant.widget.label.Standard().createLbl(label, width, required, requiredTxt);
                return lbl;
            },
            _createBtn : function (txt, clr, width, cb, ctx) {
                let btn = new venditabant.widget.button.Standard().createBtn(txt, clr, width, cb, ctx)

                return btn;
            },
        }
    });
