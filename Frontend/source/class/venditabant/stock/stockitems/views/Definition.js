
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

                let validator = new qx.ui.form.validation.Manager();
                this._validator = validator;

                var page1 = new qx.ui.tabview.Page("Stockitem");
                //page1.setLayout(new qx.ui.layout.VBox(4));
                page1.setLayout(new qx.ui.layout.Canvas());

                let lbl = this._createLbl(this.tr( "Stockitem" ),70);
                page1.add ( lbl, { top: 10, left: 10 } );

                let stockitem = this._createTxt(
                    this.tr( "Stockitem" ),150,true,this.tr("Stockitem is required")
                );

                page1.add ( stockitem, { top: 10, left: 90 } );
                this._stockitem = stockitem;
                this._validator.add(this._stockitem);

                lbl = this._createLbl(this.tr( "Description" ),70);
                page1.add ( lbl, { top: 10, left: 250 } );

                let descriptn = this._createTxt(
                    this.tr( "Description" ),250,true,this.tr("Description is required")
                );
                page1.add ( descriptn, { top: 10, left: 350 } );
                this._description = descriptn;
                this._validator.add(this._description);

                lbl = this._createLbl(this.tr( "Group" ),70);
                page1.add ( lbl, { top: 10, left: 630 } );
                
                let productgroups = new venditabant.settings.views.SettingsSelectBox().set({
                    width:180,
                    parameter:'PRODUCTGROUPS',
                    emptyrow:true,
                });
                let productgroupssview = productgroups.getView()
                this._productgroups = productgroups;

                page1.add ( productgroupssview, { top: 10, left: 700 } );

                lbl = this._createLbl(this.tr( "Price" ),70);
                page1.add ( lbl, { top: 50, left: 10 } );

                let price = this._createTxt(
                    this.tr( "Price" ),80,false
                );
                price.setFilter(/[0-9\.\,]/);

                page1.add ( price, { top: 50, left: 90 } );
                this._price = price;

                lbl = this._createLbl(this.tr( "PO price" ),70);
                page1.add ( lbl, { top: 50, left: 250 } );

                let purchprice = this._createTxt(
                    this.tr( "Purchase price" ),80,false
                );
                purchprice.setFilter(/[0-9\.\,]/);

                page1.add ( purchprice, { top: 50, left: 350 } );
                this._purchaseprice = purchprice;

                let currencies = new venditabant.support.views.CurrenciesSelectBox().set({
                    width:70,
                    emptyrow:true,
                });

                let currencysview = currencies.getView()
                this._currencies = currencies;
                page1.add ( currencysview, { top: 50, left: 435 } );

                lbl = this._createLbl(this.tr( "VAT" ),70);
                page1.add ( lbl, { top: 50, left: 630 } );
                let vat = new venditabant.settings.views.SettingsSelectBox().set({
                    width:180,
                    parameter:'VAT',
                    emptyrow:true,
                });
                
                let vatsview = vat.getView()
                this._vat = vat;
                page1.add ( vatsview, { top: 50, left: 700 } );

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

                lbl = this._createLbl(this.tr( "Account" ),70);
                page1.add ( lbl, { top: 90, left: 630 } );
                
                let accounts = new venditabant.settings.views.SettingsSelectBox().set({
                    width:180,
                    parameter:'ACCOUNTS',
                    emptyrow:true,
                });
                let accountsview = accounts.getView()
                page1.add ( accountsview, { top: 90, left: 700 } );
                this._accounts = accounts;

                lbl = this._createLbl(this.tr( "Unit" ),70);
                page1.add ( lbl, { top: 130, left: 630 } );
                let units = new venditabant.settings.views.SettingsSelectBox().set({
                    width:180,
                    parameter:'SALESUNITS',
                    emptyrow:true,
                });
                let unitsview = units.getView()
                page1.add ( unitsview, { top: 130, left: 700 } );
                this._unitsview = unitsview;
                this._units = units;

                let btnSignup = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 135, function ( ) {
                    if(this._validator.validate()) {
                        this.saveStockitem();
                    }
                }, this );
                page1.add ( btnSignup, { bottom: 10, left: 10 } );

                let btnCancel = this._createBtn ( this.tr ( "Cancel" ), "#FFAAAA70", 135, function ( ) {
                    this.clearScreen ( );
                }, this );
                page1.add ( btnCancel, { bottom: 10, right: 10 } )
                tabView.add(page1);
                this._createTable();

                view.add(this._table,{top:"52%", left:5, right:5,height:"45%"});

                this.loadStockitems();
                return view;
            },

            saveStockitem:function() {
                let stockitem = this._stockitem.getValue();
                let description  = this._description.getValue();
                let price  = this._price.getValue();
                let purchaseprice  = this._purchaseprice.getValue();
                let active  = this._active.getValue();
                let stocked  = this._stocked.getValue();

                var date = new Date();
                let today = date.getFullYear()+'-'+(date.getMonth()+1)+'-'+date.getDate() + ' ' +
                            date.getHours() +':' + date.getMinutes() + ':' +date.getSeconds();
                var fiveyears = (date.getFullYear()+5)+'-'+(date.getMonth()+1)+'-'+date.getDate();
                let units_fkey = this._units.getKey();
                let accounts_fkey = this._accounts.getKey();
                let vat_fkey = this._vat.getKey();
                let productgroup_fkey = this._productgroups.getKey();
                let currencies_fkey = this._currencies.getKey();

                let data = {
                    stockitem: stockitem,
                    description: description,
                    price:price,
                    purchaseprice:purchaseprice,
                    active:active,
                    stocked:stocked,
                    fromdate: today,
                    todate:fiveyears,
                    units_fkey: units_fkey,
                    accounts_fkey:accounts_fkey,
                    vat_fkey:vat_fkey,
                    productgroup_fkey:productgroup_fkey,
                    currencies_fkey:currencies_fkey,
                }
                let com = new venditabant.communication.Post ( );
                com.send ( this._address, "/api/v1/stockitem/save/", data, function ( success ) {
                    let win = null;
                    if ( success )  {
                        this.loadStockitems();
                        this.clearScreen();
                    }
                    else  {
                        alert ( this.tr ( 'Something went wront with the save, please try again' ) );
                    }
                }, this );

            },
            clearScreen:function() {
                this._stockitem.setValue('');
                this._description.setValue('');
                this._price.setValue('');
                this._purchaseprice.setValue('');
                this._active.setValue(false);
                this._stocked.setValue(false);
                this._units.setSelectedModel();
                this._accounts.setSelectedModel();
                this._vat.setSelectedModel();
                this._productgroups.setSelectedModel();
                this._currencies.setSelectedModel();
            },
            _createTable : function() {
                // Create the initial data
                let rowData =  '';
                let that = this;

                // table model
                var tableModel = new qx.ui.table.model.Simple();
                tableModel.setColumns([
                    this.tr("ID"), this.tr("Stockitem"), this.tr("Description"), this.tr("Price"),
                    this.tr("Purchase Price"),this.tr("Active"),
                    this.tr("Stocked"), this.tr("Unit"), this.tr("Account"),
                    this.tr("VAT"), this.tr("Product group"),
                    this.tr("currencies_fkey"), this.tr("suppliers_pkey"), this.tr("PO Currency") ]);
                tableModel.setData(rowData);

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

                    that._units.setSelectedModel(selectedRows[0][7]);
                    that._accounts.setSelectedModel(selectedRows[0][8]);
                    that._vat.setSelectedModel(selectedRows[0][9]);
                    that._productgroups.setSelectedModel(selectedRows[0][10]);
                    that._currencies.setKey(selectedRows[0][11]);
                });
                var tcm = table.getTableColumnModel();
                tcm.setColumnVisible(0,false);
                tcm.setColumnVisible(11,false);
                tcm.setColumnVisible(12,false);
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
                    if(response.data !== null){
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
                                response.data[i].unit,
                                response.data[i].account,
                                response.data[i].vat,
                                response.data[i].productgroup,
                                response.data[i].currencies_pkey,
                                response.data[i].suppliers_pkey,
                                response.data[i].shortdescription,
                            ]);
                        }
                    }
                    this._table.getTableModel().setData(tableData);
                    //alert("Set table data here");
                }, this);
                //return ;//list;
            },

        }
    });
