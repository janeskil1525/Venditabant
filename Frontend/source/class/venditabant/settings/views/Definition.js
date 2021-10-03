
qx.Class.define ( "venditabant.settings.views.Definition",
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
                let that = this;
                let view = new qx.ui.container.Composite(new qx.ui.layout.Canvas());
                view.setBackgroundColor("white");

                // Add a TabView
                var tabView = new qx.ui.tabview.TabView();
                view.add(tabView, {top: 0, left: 5, right: 5, height: "1000%"});

                var page1 = new qx.ui.tabview.Page(this.tr("Sales"));
                //page1.setLayout(new qx.ui.layout.VBox(4));
                page1.setLayout(new qx.ui.layout.Canvas());

                var box1 = new qx.ui.groupbox.GroupBox(this.tr("VAT"), null);
                box1.setLayout(new qx.ui.layout.VBox());
                page1.add(box1);

                let vat_txt = this._createTxt(
                    this.tr( "VAT" ),120,true,this.tr("VAT is required")
                );
                this._vat_txt = vat_txt;
                vat_txt.addListener("input",function(e){
                    let value = e.getData();
                },this);
                box1.add(vat_txt);
                let vat_desc = this._createTxt(
                    this.tr( "Description" ),120,true,this.tr("VAT is required")
                );
                this._vat_desc = vat_desc;
                box1.add(vat_desc);
                let save_VAT = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 120, function ( ) {
                    this.saveVAT ( );
                }, this );
                box1.add(save_VAT);

                var oneList = new qx.ui.form.List();
                oneList.addListener("changeSelection",function(e) {
                    let selection = e.getData()[0].getLabel();

                    this._vat_txt.setValue(selection);
                    this._vat_desc.setValue(selection);

                },this)

                oneList.set({ height: 100, width: 150, selectionMode : "one" });
                var item;
                for (var i=1; i<=25; i++) {
                    item = new qx.ui.form.ListItem("Item No " + i, null);
                    oneList.add(item);
                }

                box1.add(oneList);
                page1.add ( box1, { top: 0, left: 10 } );

                tabView.add(page1);

                var page2 = new qx.ui.tabview.Page("Stock");
                tabView.add(page2);

                var page3 = new qx.ui.tabview.Page("Mails");
                tabView.add(page3);

                var page4 = new qx.ui.tabview.Page("Sales");
                tabView.add(page4);

                return view;
            },
            saveVAT:function() {
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
