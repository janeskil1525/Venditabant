qx.Class.define ( "venditabant.sales.customers.views.StockitemDiscounts",
    {
            extend: venditabant.application.base.views.Base,
            include: [qx.locale.MTranslation],
            construct: function () {
            },
            destruct: function () {
            },
            properties: {
                support: {nullable: true, check: "Boolean"},
                customers_fkey:{nullable:true, check:"Number"},
            },
            members: {
                    // Public functions ...
                    getView: function () {
                        let box1 = new qx.ui.groupbox.GroupBox(this.tr("Stockitems"), null);
                        box1.setLayout(new qx.ui.layout.VBox());

                        let stockitems = new qx.ui.form.SelectBox();
                        stockitems.setWidth( 150 );
                        stockitems.addListener("changeSelection", function(e) {
                            let selection = e.getData()[0].getModel();
                            this._selectedStockitem = selection;
                        },this);
                        this._stockitems = stockitems;
                        this.loadStockitems();
                        box1.add(stockitems);

                        let container = new qx.ui.container.Composite(new qx.ui.layout.HBox(6));

                        let lbl = this._createLbl(this.tr( "Discount" ),90);
                        let stockitem_discounts_txt = this._createTxt(
                            this.tr( "Discount" ),100,true,
                            this.tr("Dicount is required"),
                            this.tr("Either amount or percentage ended with %")
                        );
                        // stockitem_discounts_txt.setFilter(/[0-9]\%/);
                        this._stockitem_discounts_txt = stockitem_discounts_txt;
                        stockitem_discounts_txt.addListener("input",function(e){
                            let value = e.getData();
                        },this);
                        container.add(lbl,{flex:1});
                        container.add(stockitem_discounts_txt);
                        box1.add(container);

                        //box1.add(invoicedays_desc);
                        let save_stockitem_discounts = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 120, function ( ) {
                            this.save_stockitem_discounts ( );
                        }, this );
                        box1.add(save_stockitem_discounts);

                        var discountlist = new qx.ui.form.List();
                        discountlist.addListener("changeSelection",function(e) {
                            let selection = e.getData()[0].getLabel();
                            let stockitem_discounts_txt = selection.substring(0,selection.indexOf(' '));
                            //let invoicedays_desc = selection.substring(selection.indexOf(' '));

                            this._stockitem_discounts_txt.setValue(stockitem_discounts_txt);

                            //this._invoicedays_desc.setValue(invoicedays_desc);

                        },this);

                        discountlist.set({ height: 100, width: 200, selectionMode : "one" });

                        this._discountlist = discountlist;
                        box1.add(discountlist);
                        if(this.getCustomers_fkey() > 0) {
                            this.loadStockitemDiscounts(this.getCustomers_fkey());
                        }
                        return box1;
                    },
                save_stockitem_discounts:function() {
                    let that = this;
                    let data = {
                        discount:this._stockitem_discounts_txt.getValue(),
                        customers_fkey:this.getCustomers_fkey(),
                        stockitems_fkey:this._selectedStockitem.stockitems_pkey,
                    };
                    let put = new venditabant.sales.customers.models.StockitemsDiscount();
                    put.saveStockitemDiscount(data,function(success) {
                        if(success.status !== 'success'){
                            alert(this.tr('Something went wrong saving the invoice address'));
                        } else {
                            that.setCustomerAddressFkey(success.data);
                        }
                    }, this)
                    this.loadStockitemDiscounts(this.getCustomers_fkey());
                },
                loadStockitemDiscounts:function (customers_fkey) {
                    let stockitems = new venditabant.sales.customers.models.StockitemsDiscount();
                    stockitems.loadList(function(response, rsp) {
                        if(response.data !== null) {
                            let tableData = [];
                            for(let i = 0; i < response.data.length; i++) {
                                let tempItem = new qx.ui.form.ListItem(response.data[i].stockitem);
                                this._discountlist.add(tempItem);
                            }
                        }
                    }, this, customers_fkey);
                },
                loadStockitems:function () {
                    let stockitems = new venditabant.stock.stockitems.models.Stockitem();
                    stockitems.loadList(function(response, rsp) {
                        if(response.data !== null) {
                            let tableData = [];
                            for(let i = 0; i < response.data.length; i++) {
                                let tempItem = new qx.ui.form.ListItem(response.data[i].stockitem);
                                tempItem.setModel(response.data[i]);
                                this._stockitems.add(tempItem);
                            }
                        }
                    }, this);
                },
            }
    });