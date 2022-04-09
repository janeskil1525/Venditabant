
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
            _customers_pkey:0,
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

                this._discounts = new venditabant.sales.customers.views.Discounts();
                tabView.add(this._discounts.getView());

                this._createTable();
                view.add(this._table,{top:"52%", left:5, right:5,height:"45%"});
                this.loadCustomers();

                return view;
            },
            getDefinition:function () {
                var page1 = new qx.ui.tabview.Page(this.tr("Customer"));
                //page1.setLayout(new qx.ui.layout.VBox(4));
                page1.setLayout(new qx.ui.layout.Canvas());

                let lbl = this._createLbl(this.tr( "Customer" ), 70);
                page1.add ( lbl, { top: 10, left: 10 } );

                let customer = this._createTxt("Customer", 150, true,
                    this.tr("Customer is required"),
                    this.tr('Unique id for the customer set automatically if left empty')
                );
                page1.add ( customer, { top: 10, left: 90 } );
                this._customer = customer;

                lbl = this._createLbl(this.tr( "Name" ), 70);
                page1.add ( lbl, { top: 10, left: 250 } );

                let name = this._createTxt("Name", 250, false,'',
                    this.tr('Customers formal name')
                );
                page1.add ( name, { top: 10, left: 350 } );
                this._name = name

                lbl = this._createLbl(this.tr( "Org. nr" ), 70);
                page1.add ( lbl, { top: 45, left: 250 } );

                let orgnbr = this._createTxt("Org. nr", 250, false, '',
                    this.tr('Customers organisational or VAT id')
                );
                page1.add ( orgnbr, { top: 45, left: 350 } );
                this._registrationnumber = orgnbr
                lbl = this._createLbl(this.tr( "Pricelist" ), 70);
                page1.add ( lbl, { top: 45, left: 10 } );

                let pricelists = new venditabant.sales.pricelists.views.PricelistsSelectBox().set({
                    width:150,
                    emptyrow:false,
                    tooltip:this.tr( "Select pricelist for customer" ),
                });
                this._pricelists = pricelists;
                page1.add ( pricelists.getView(), { top: 45, left: 90 } );

                lbl = this._createLbl(this.tr( "Phone" ), 70);
                page1.add ( lbl, { top: 80, left: 10 } );

                let phone = this._createTxt("Phone", 150, true,
                    this.tr("Customer phon number is required"),
                    this.tr('The customers official phonnumber')
                );
                page1.add ( phone, { top: 80, left: 90 } );
                this._phone = phone;

                lbl = this._createLbl(this.tr( "Homepage" ), 70);
                page1.add ( lbl, { top: 80, left: 250 } );

                let homepage = this._createTxt(this.tr("Homepage"), 250, false,'',
                    this.tr('The customers official homepage, if exists')
                );
                page1.add ( homepage, { top: 80, left: 350 } );
                this._homepage = homepage

                lbl = this._createLbl(this.tr( "Language" ), 70);
                page1.add ( lbl, { top: 115, left: 10 } );

                let languages = new venditabant.support.views.LanguageSelectBox().set({
                    width:150,
                    emptyrow:false,
                    tooltip:this.tr( "Select customer language" ),
                });
                let languagesview = languages.getView()
                this._languages = languages;
                page1.add ( languagesview, { top: 115, left: 90 } );

                let active = this._createChkBox(this.tr ( "Active" ), "#FFAAAA70", 135, function ( ) {
                    //this.clearScreen();
                }, this, this.tr('The customers is active or not, shown here as information only') );
                active.setEnabled(false);
                this._active = active;
                page1.add ( active, { bottom: 65, left: 10 } );

                let blocked = this._createChkBox(this.tr ( "Blocked" ), "#FFAAAA70", 135, function ( ) {
                    //this.clearScreen();
                }, this, this.tr('The customers is blocked or not, shown here as information only') );
                blocked.setEnabled(false);
                this._blocked = blocked;
                page1.add ( blocked, { bottom: 65, left: 90 } );

                lbl = this._createLbl(this.tr( "Comment" ), 120);
                page1.add ( lbl, { top: 115, left: 250 } );

                let comment = this._createTextArea(this.tr("Comment"), 250, false,'',
                    this.tr('Internal comment regarding the customer')
                );
                this._comment = comment;

                page1.add ( comment, { top: 115, left: 350 } );

                let btnSave = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 135, function ( ) {
                    this.saveCustomer ( );
                }, this, this.tr('Save the customer'));
                page1.add ( btnSave, { bottom: 10, left: 10 } );

                let btnNew = this._createBtn ( this.tr ( "New" ), "#FFAAAA70", 135, function ( ) {
                    this.clearScreen();
                }, this, this.tr('Enter a new customer') );
                page1.add ( btnNew, { bottom: 10, right: 10 } );

                return page1;
            },
            clearScreen:function() {
                this._customers_pkey = 0;
                this._customer.setValue('');
                this._name.setValue('');
                this._registrationnumber.setValue('')
                this._homepage.setValue('');
                this._phone.setValue('');
                this._pricelists.setSelectedModel();
                this._comment.setValue('')
                this._active.setValue(true);
                this._blocked.setValue(false);
            },
            saveCustomer:function() {
                let that = this;
                let customers_pkey = this._customers_pkey;
                let customer = this._customer.getValue();
                let name  = this._name.getValue();
                let registrationnumber = this._registrationnumber.getValue();
                let homepage = this._homepage.getValue();
                let phone = this._phone.getValue();
                let pricelists_fkey = this._pricelists.getKey();;
                let comment = this._comment.getValue();
                let languages_fkey = this._languages.getKey();
                let active = this._active.getValue();
                let blocked = this._blocked.getValue();
                let data = {
                    customers_pkey: customers_pkey,
                    customer: customer,
                    name: name,
                    registrationnumber: registrationnumber,
                    homepage: homepage,
                    phone: phone,
                    pricelists_fkey: pricelists_fkey,
                    comment:comment,
                    languages_fkey:languages_fkey,
                    active:active,
                    blocked:blocked,
                }
                let model = new venditabant.sales.customers.models.Customers();
                model.saveCustomer(data,function ( success ) {
                    if (success) {
                        that.loadCustomers();
                        that.clearScreen();
                    } else {
                        alert(this.tr('Something went wrong saving the customer'));
                    }
                },this);
            },
            _createTable : function() {
                // Create the initial data
                let rowData =  '';
                let that = this;

                // table model
                var tableModel = new qx.ui.table.model.Simple();
                tableModel.setColumns([
                    this.tr("ID"),
                    this.tr("Customer"),
                    this.tr("Name"),
                    this.tr("Pricelist"),
                    this.tr("Org. nr."),
                    this.tr("Phone"),
                    this.tr("Homepage"),
                    this.tr("Comment"),
                    this.tr("languages_fkey"),
                    this.tr("active"),
                    this.tr("blocked")
                ]);
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

                    that._customers_pkey = selectedRows[0][0];
                    that._customer.setValue(selectedRows[0][1]);
                    that._name.setValue(selectedRows[0][2]);
                    that._registrationnumber.setValue(selectedRows[0][4]);
                    that._homepage.setValue(selectedRows[0][6]);
                    that._phone.setValue(selectedRows[0][5]);
                    that._pricelists.setSelectedModel(selectedRows[0][3]);

                    that._invoice.setCustomersFkey(selectedRows[0][0]);
                    that._invoice.setCustomerName(selectedRows[0][2]);
                    that._delivery.setCustomersFkey(selectedRows[0][0]);
                    that._discounts.setCustomersFkey(selectedRows[0][0]);
                    that._comment.setValue(selectedRows[0][7]);
                    that._languages.setKey(selectedRows[0][8])
                    let active = selectedRows[0][9] ? true : false;
                    let blocked = selectedRows[0][10] ? true : false;
                    that._active.setValue(active);
                    that._blocked.setValue(blocked);
                });
                var tcm = table.getTableColumnModel();
                tcm.setColumnVisible(0,false);
                tcm.setColumnVisible(8,false);
                tcm.setColumnVisible(9,false);
                tcm.setColumnVisible(10,false);
                tcm.setColumnWidth(7,300)
                tcm.setColumnWidth(2,200)

                this._table = table;

                return ;
            },
            loadCustomers:function () {
                let customers = new venditabant.sales.customers.models.Customers();
                customers.loadList(function(response) {
                    if(response.data !== null) {
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
                                response.data[i].comment,
                                response.data[i].languages_fkey,
                                response.data[i].active,
                                response.data[i].blocked,
                            ]);
                        }
                        this._table.getTableModel().setData(tableData);
                    }
                }, this);
                //return ;//list;
            }
        }
    });
