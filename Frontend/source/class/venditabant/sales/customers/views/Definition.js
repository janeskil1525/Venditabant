
qx.Class.define ( "venditabant.sales.customers.views.Definition",
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
                var win = new qx.ui.window.Window("Customers", "icon/16/apps/internet-feed-reader.png");
                win.setLayout(new qx.ui.layout.VBox(10));
                win.setStatus("Application is ready");
                win.open();
                let app = qx.core.Init.getApplication();
                let root = app.getRoot();
                root.add(win, {left: 350, top: 120});

                var atom = new qx.ui.basic.Atom("Manage customers", "icon/22/apps/utilities-calculator.png");
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

                let pricelists = new qx.ui.form.SelectBox();

                pricelists.addListener("changeSelection", function(e) {
                    let selection = e.getData()[0].getLabel();

                    this._selectedPricelistHead = selection;
                },this);

                pricelists.setWidth( 150 );
                this._pricelists = pricelists;
                this.loadPricelists();

                page1.add ( pricelists, { top: 50, left: 90 } );

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
                    this.cancel ( );
                }, this );
                page1.add ( btnCancel, { bottom: 10, right: 10 } );

                tabView.add(page1);

                var page2 = new qx.ui.tabview.Page("Addresses");
                tabView.add(page2);

                var page3 = new qx.ui.tabview.Page("Mails");
                tabView.add(page3);

                var page4 = new qx.ui.tabview.Page("Sales");
                tabView.add(page4);

                this._createTable();
                win.add(this._table);

                this.loadCustomers();
            },
            saveCustomer:function() {
                let that = this;
                let customer = this._customer.getValue();
                let name  = this._name.getValue();
                let registrationnumber = this._registrationnumber.getValue();
                let homepage = this._homepage.getValue();
                let phone = this._phone.getValue();
                let pricelist = this._selectedPricelistHead;

                let data = {
                    customer: customer,
                    name: name,
                    registrationnumber: registrationnumber,
                    homepage: homepage,
                    phone: phone,
                    pricelist: pricelist,
                }
                let model = new venditabant.sales.customers.models.Customers();
                model.saveCustomer(data,function ( success ) {
                    if (success) {
                        that.loadCustomers();
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
            _createBtn : function (txt, clr, width, cb, ctx) {
                let btn = new venditabant.widget.button.Standard().createBtn(txt, clr, width, cb, ctx)

                return btn;
            },
            _createTxt:function(placeholder, width, required, requiredTxt) {
                let txt = new venditabant.widget.textfield.Standard().createTxt(placeholder, width, required, requiredTxt);
                return txt;
            },
            _createLbl:function(label, width, required, requiredTxt) {
                let lbl = new venditabant.widget.label.Standard().createLbl(label, width, required, requiredTxt);
                return lbl;
            },
            _createTable : function() {
                // Create the initial data
                let rowData =  '';
                let that = this;

                // table model
                var tableModel = new qx.ui.table.model.Simple();
                tableModel.setColumns([ "ID", "Customer", "Name", "Pricelist", "Org. nr.", "Phone", "Homepage" ]);
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

                    that._customer.setValue(selectedRows[0][1]);
                    that._name.setValue(selectedRows[0][2]);
                    that._registrationnumber.setValue(selectedRows[0][4]);
                    that._homepage.setValue(selectedRows[0][6]);
                    that._phone.setValue(selectedRows[0][5]);
                    that._selectedPricelistHead = selectedRows[0][3];

                });
                var tcm = table.getTableColumnModel();

                // Display a checkbox in column 3
                //tcm.setDataCellRenderer(3, new qx.ui.table.cellrenderer.Boolean());

                // use a different header renderer
                //tcm.setHeaderCellRenderer(2, new qx.ui.table.headerrenderer.Icon("icon/16/apps/office-calendar.png", "A date"));

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
