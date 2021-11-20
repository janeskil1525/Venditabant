

qx.Class.define ( "venditabant.sales.customers.views.ProductGroupDiscounts",
    {
            extend: venditabant.application.base.views.Base,
            include: [qx.locale.MTranslation],
            construct: function () {
            },
            destruct: function () {
            },
            properties: {
                    support: {nullable: true, check: "Boolean"}
            },
            members: {
                    // Public functions ...
                _customers_fkey:0,
                getView: function () {
                    let box1 = new qx.ui.groupbox.GroupBox(this.tr("Product group"), null);
                    box1.setLayout(new qx.ui.layout.VBox());

                    let productgroups = new qx.ui.form.SelectBox();
                    productgroups.setWidth( 150 );
                    productgroups.addListener("changeSelection", function(e) {
                        let selection = e.getData()[0].getLabel();
                        this._selectedProductgroups= selection;
                    },this);
                    this._productgroups = productgroups;
                    this.loadProductgroups();
                    box1.add(productgroups);

                    let container = new qx.ui.container.Composite(new qx.ui.layout.HBox(6));

                    let lbl = this._createLbl(this.tr( "Discount" ),90);
                    let discount_txt = this._createTxt(
                        this.tr( "Discount" ),100,true,
                        this.tr("Dicount is required"),
                        this.tr("Either amount or percentage ended with %")
                    );
                    this._discount_txt = discount_txt;

                    container.add(lbl,{flex:1});
                    container.add(discount_txt);
                    box1.add(container);

                    //box1.add(invoicedays_desc);
                    let save_productgroup_discounts = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 120, function ( ) {
                        this.save_productgroup_discounts ( );
                    }, this );
                    box1.add(save_productgroup_discounts );

                    var discountlist  = new qx.ui.form.List();
                    discountlist.addListener("changeSelection",function(e) {
                        if(typeof e.getData()[0] !== 'undefined') {
                            let model = e.getData()[0].getModel();
                            this.load_productgroup_discounts(model.customers_fkey);
                            this._discount_txt.setValue(model.discount);
                        } else {
                            this._discount_txt.setValue('');
                        }

                    },this);

                    discountlist.set({ height: 100, width: 200, selectionMode : "one" });
                    this._discountlist = discountlist;
                    box1.add(discountlist);
                    if(this.getCustomersFkey() > 0) {
                        this.load_productgroup_discounts(this.getCustomers_fkey());
                    }

                    return box1;
                },
                save_productgroup_discounts:function(customers_fkey) {

                },
                load_productgroup_discounts:function() {

                },
                loadProductgroups:function () {
                    let get = new venditabant.settings.models.Settings();
                    get.loadList(function(response) {
                        if(response.data !== null) {
                            var item;
                            for (let i=0; i < response.data.length; i++) {
                                let row = response.data[i].param_value + ' ' + response.data[i].param_description;
                                item = new qx.ui.form.ListItem(row, null);
                                this._productgroups.add(item);
                            }
                        }
                    },this,'PRODUCTGROUPS');
                },
                clearScreen:function() {

                },
                setCustomersFkey:function(customers_fkey) {
                    this.clearScreen();
                    this._customers_fkey = customers_fkey;
                    this.load_productgroup_discounts(customers_fkey);
                },
                getCustomersFkey:function() {
                    return this._customers_fkey;
                },
            }
    });