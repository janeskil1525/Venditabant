

qx.Class.define ( "venditabant.sales.customers.views.GeneralDiscounts",
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
                _selected_discount:null,
                    getView: function () {
                        let box1 = new qx.ui.groupbox.GroupBox(this.tr("General"), null);
                        box1.setLayout(new qx.ui.layout.VBox());

                       let container = new qx.ui.container.Composite(new qx.ui.layout.HBox(6));

                        let lbl = this._createLbl(this.tr( "Sum" ),90);
                        let minimumsum_txt = this._createTxt(
                            this.tr( "Sum" ),100,true,
                            this.tr("Sum is required"),
                            this.tr("Minimum sum to triggerdiscount is requires")
                        );
                        this._minimumsum_txt = minimumsum_txt;

                        container.add(lbl,{flex:1});
                        container.add(minimumsum_txt);
                        box1.add(container);

                        let container2 = new qx.ui.container.Composite(new qx.ui.layout.HBox(6));

                        lbl = this._createLbl(this.tr( "Discount" ),90);
                        let discount_txt = this._createTxt(
                            this.tr( "Discount" ),100,true,
                            this.tr("Dicount is required"),
                            this.tr("Either amount or percentage ended with %")
                        );
                        this._discount_txt = discount_txt;

                        container2.add(lbl,{flex:1});
                        container2.add(discount_txt);
                        box1.add(container2);

                        //box1.add(invoicedays_desc);
                        let container3 = new qx.ui.container.Composite(new qx.ui.layout.HBox(6));
                        let save_discount = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 120, function ( ) {
                            this.save_general_discount ( );
                        }, this );
                        container3.add(save_discount)

                        let delete_discount = this._createBtn ( this.tr ( "Delete" ), "rgba(239,170,255,0.44)", 120, function ( ) {
                            this.delete_general_discount ( );
                        }, this );
                        container3.add(delete_discount)

                        box1.add(container3);

                        var general_discountlist = new qx.ui.form.List();
                        general_discountlist.addListener("changeSelection",function(e) {
                            if(typeof e.getData()[0] !== 'undefined') {
                                let model = e.getData()[0].getModel();
                                this._minimumsum_txt.setValue(model.minimumsum);
                                this._discount_txt.setValue(model.discount);
                                this._selected_discount = model;
                            } else {
                                this._minimumsum_txt.setValue('');
                                this._discount_txt.setValue('');
                                this._selected_discount = null;
                            }
                        },this);

                        general_discountlist.set({ height: 100, width: 200, selectionMode : "one" });

                        this._general_discountlist = general_discountlist;
                        box1.add(general_discountlist);

                        return box1;
                    },
                delete_general_discount:function() {
                    let that = this;
                    let put = new venditabant.sales.customers.models.GeneralDiscounts();
                    put.deleteGeneralDiscount(this._selected_discount.customer_discount_pkey,function(response) {
                        if(response.result !== 'success'){
                            alert(this.tr('Something went wrong deleteing the general discount'));
                        } else {
                            that.loadGeneralDiscount(this.getCustomersFkey());
                        }
                    }, this);
                },
                save_general_discount:function() {
                    let that = this;
                    let data = {
                        discount:this._discount_txt.getValue(),
                        minimumsum:this._minimumsum_txt.getValue(),
                        customers_fkey:this.getCustomersFkey(),
                    };

                    let put = new venditabant.sales.customers.models.GeneralDiscounts();
                    put.saveGeneralDiscount(data,function(success) {
                        if(success !== 'success'){
                            alert(this.tr('Something went wrong saving the invoice address'));
                        } else {
                            that.loadGeneralDiscount(this.getCustomersFkey());
                        }
                    }, this);
                },
                loadGeneralDiscount: function(customers_fkey) {
                    let stockitems = new venditabant.sales.customers.models.GeneralDiscounts();
                    stockitems.loadList(function(response) {
                        this._general_discountlist.removeAll();
                        if(response.data !== null) {
                            let tableData = [];
                            for(let i = 0; i < response.data.length; i++) {
                                let text = response.data[i].discount + ' ' + response.data[i].minimumsum
                                let tempItem = new qx.ui.form.ListItem(text);
                                tempItem.setModel(response.data[i]);
                                this._general_discountlist.add(tempItem);
                            }
                        }
                    }, this, customers_fkey);
                },
                clearScreen:function() {

                },
                setCustomersFkey: function(customers_fkey) {
                    this.clearScreen();
                    this._customers_fkey = customers_fkey;
                    this.loadGeneralDiscount(customers_fkey);
                },
                getCustomersFkey:function() {
                    return this._customers_fkey;
                },
            }
    });