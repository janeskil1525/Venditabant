
qx.Class.define ( "venditabant.sales.customers.views.Definition",
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
            setParams: function (params) {
            },
            getView: function () {
                let view = new qx.ui.container.Composite(new qx.ui.layout.Canvas());
                view.setBackgroundColor("white");

                // Add a TabView
                var tabView = new qx.ui.tabview.TabView();
                view.add(tabView, {top: 0, left: 5, right: 5, height: "50%"});
                let page1 = this.getDefinition();
                tabView.add(page1);


                //let page2 = this.getInvoice();
                this._invoice = new venditabant.sales.customers.views.Invoice().set({
                    support:this.isSupport(),
                });
                tabView.add(this._invoice.getView());

                this._delivery = new venditabant.sales.customers.views.Delivery();

                //let page3 = this.getDelivery();
                tabView.add(this._delivery.getView());


                let page4 = this.getDiscounts();
                tabView.add(page4);

                this._createTable();
                view.add(this._table,{top:"52%", left:5, right:5,height:"45%"});
                this.loadCustomers();

                return view;
            },
            getDiscounts:function() {
                var page4 = new qx.ui.tabview.Page("Discounts");
                page4.setLayout(new qx.ui.layout.Canvas());


                let box1 = new venditabant.sales.customers.views.StockitemDiscounts().getView();
                page4.add ( box1, { top: 0, left: 10 } );

                let box2 = new venditabant.sales.customers.views.ProductGroupDiscounts().getView();
                page4.add ( box2, { top: 0, left: 250 } );

                let box3 = new venditabant.sales.customers.views.GeneralDiscounts().getView();
                page4.add ( box3, { top: 0, left: 490 } );
                return page4;
            },
            getDelivery:function() {
                let page3 = new qx.ui.tabview.Page("Delivery");
                page3.setLayout(new qx.ui.layout.Canvas());

                let lbl = this._createLbl(this.tr( "Address" ), 70);
                page3.add ( lbl, { top: 10, left: 10 } );

                let lev_address = new qx.ui.form.SelectBox();
                lev_address.setWidth( 250 );
                lev_address.addListener("changeSelection", function(e) {
                    let selection = e.getData()[0].getLabel();
                    this._selectedLev_address = selection;
                },this);
                page3.add ( lev_address, { top: 10, left: 90 } );

                let address1 = this._createTxt("Street", 250, false, '');
                page3.add ( address1, { top: 45, left: 90 } );
                this._del_address1 = address1;

                let address2 = this._createTxt("Address", 250, false, '');
                page3.add ( address2, { top: 80, left: 90 } );
                this._del_address2 = address2;

                let address3 = this._createTxt("City Zipcode", 250, false, '');
                page3.add ( address3, { top: 115, left: 90 } );
                this._del_address3 = address3

                let address4 = this._createTxt("Country", 250, false, '');
                page3.add ( address4, { top: 150, left: 90 } );
                this._del_address4 = address4;

                lbl = this._createLbl(this.tr( "Mail addressses" ), 120);
                page3.add ( lbl, { top: 10, left: 380 } );

                let deliverymails = this._createTxt(this.tr("Comma separated mail adresses"), 420, false, '');
                page3.add ( deliverymails, { top: 10, left: 500 } );
                this._deliverymails = deliverymails;

                let btnSignup = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 135, function ( ) {
                    this.saveInvoiceData ( );
                }, this );
                page3.add ( btnSignup, { bottom: 10, left: 10 } );

                let btnCancel = this._createBtn ( this.tr ( "Cancel" ), "#FFAAAA70", 135, function ( ) {
                    this.cancel ( );
                }, this );
                page3.add ( btnCancel, { bottom: 10, right: 10 } );
                return page3;
            },

            getDefinition:function () {
                var page1 = new qx.ui.tabview.Page(this.tr("Definition"));
                //page1.setLayout(new qx.ui.layout.VBox(4));
                page1.setLayout(new qx.ui.layout.Canvas());

                let lbl = this._createLbl(this.tr( "Customer" ), 70);
                page1.add ( lbl, { top: 10, left: 10 } );

                let customer = this._createTxt("Customer", 150, true, this.tr("Customer is required"));
                page1.add ( customer, { top: 10, left: 90 } );
                this._customer = customer;

                lbl = this._createLbl(this.tr( "Name" ), 70);
                page1.add ( lbl, { top: 10, left: 250 } );

                let name = this._createTxt("Name", 250, false);
                page1.add ( name, { top: 10, left: 350 } );
                this._name = name

                lbl = this._createLbl(this.tr( "Org. nr" ), 70);
                page1.add ( lbl, { top: 50, left: 250 } );

                let orgnbr = this._createTxt("Org. nr", 250, false);
                page1.add ( orgnbr, { top: 50, left: 350 } );
                this._registrationnumber = orgnbr


                lbl = this._createLbl(this.tr( "Pricelist" ), 70);
                page1.add ( lbl, { top: 50, left: 10 } );

                let pricelists = new venditabant.sales.pricelists.views.PricelistsSelectBox().set({
                    width:150,
                    emptyrow:false,
                });
                this._pricelists = pricelists;
                page1.add ( pricelists.getView(), { top: 50, left: 90 } );

                lbl = this._createLbl(this.tr( "Phone" ), 70);
                page1.add ( lbl, { top: 90, left: 10 } );

                let phone = this._createTxt("Phone", 150, true, this.tr("Customer is required"));
                page1.add ( phone, { top: 90, left: 90 } );
                this._phone = phone;

                lbl = this._createLbl(this.tr( "Homepage" ), 70);
                page1.add ( lbl, { top: 90, left: 250 } );

                let homepage = this._createTxt("Homepage", 250, false);
                page1.add ( homepage, { top: 90, left: 350 } );
                this._homepage = homepage

                let btnSignup = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 135, function ( ) {
                    this.saveCustomer ( );
                }, this );
                page1.add ( btnSignup, { bottom: 10, left: 10 } );

                let btnCancel = this._createBtn ( this.tr ( "Cancel" ), "#FFAAAA70", 135, function ( ) {
                    this.clearScreen();
                }, this );
                page1.add ( btnCancel, { bottom: 10, right: 10 } );

                return page1;
            },
            clearScreen:function() {
                this._customer.setValue('');
                this._name.setValue('');
                this._registrationnumber.setValue('')
                this._homepage.setValue('');
                this._phone.setValue('');
                this._pricelists.setSelectedModel();
            },
            saveCustomer:function() {
                let that = this;
                let customer = this._customer.getValue();
                let name  = this._name.getValue();
                let registrationnumber = this._registrationnumber.getValue();
                let homepage = this._homepage.getValue();
                let phone = this._phone.getValue();
                let pricelists_fkey = this._pricelists.getKey();;

                let data = {
                    customer: customer,
                    name: name,
                    registrationnumber: registrationnumber,
                    homepage: homepage,
                    phone: phone,
                    pricelists_fkey: pricelists_fkey,
                }
                let model = new venditabant.sales.customers.models.Customers();
                model.saveCustomer(data,function ( success ) {
                    if (success) {
                        that.loadCustomers();
                        this.clearScreen();
                    } else {
                        alert(this.tr('Something went wrong saving the customer'));
                    }
                },this);
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
            _createTable : function() {
                // Create the initial data
                let rowData =  '';
                let that = this;

                // table model
                var tableModel = new qx.ui.table.model.Simple();
                tableModel.setColumns([ "ID", "Customer", "Name", "Pricelist", "Org. nr.", "Phone", "Homepage" ]);
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

                    that._customer.setValue(selectedRows[0][1]);
                    that._name.setValue(selectedRows[0][2]);
                    that._registrationnumber.setValue(selectedRows[0][4]);
                    that._homepage.setValue(selectedRows[0][6]);
                    that._phone.setValue(selectedRows[0][5]);
                    that._pricelists.setSelectedModel(selectedRows[0][3]);

                    that._invoice.setCustomersFkey(selectedRows[0][0]);
                    that._invoice.setCustomerName(selectedRows[0][2]);
                    that._delivery.setCustomersFkey(selectedRows[0][0]);
                });
                var tcm = table.getTableColumnModel();

                this._table = table;

                return ;
            },
            loadCustomers:function () {
                let customers = new venditabant.sales.customers.models.Customers();
                customers.loadList(function(response) {
                    let tableData = [];
                    for(let i = 0; i < response.data.length; i++) {

                        tableData.push([
                            response.data[i].customers_pkey,
                            response.data[i].customer,
                            response.data[i].name,
                            response.data[i].pricelist,
                            response.data[i].registrationnumber,
                            response.data[i].phone,
                            response.data[i].homepage,
                        ]);
                    }
                    this._table.getTableModel().setData(tableData);
                    //alert("Set table data here");
                }, this);
                //return ;//list;
            }
        }
    });
