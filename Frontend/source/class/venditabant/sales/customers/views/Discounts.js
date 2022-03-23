qx.Class.define ( "venditabant.sales.customers.views.Discounts",
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
            _customers_fkey: 0,
            getView: function () {
                var page4 = new qx.ui.tabview.Page(this.tr("Discounts"));
                page4.setLayout(new qx.ui.layout.Canvas());


                let stockitemdiscounts = new venditabant.sales.customers.views.StockitemDiscounts();
                this._stockitemdiscounts = stockitemdiscounts;
                page4.add ( this._stockitemdiscounts.getView(), { top: 0, left: 10 } );

                let productgroupdiscounts = new venditabant.sales.customers.views.ProductGroupDiscounts();
                this._productgroupdiscounts = productgroupdiscounts;
                page4.add (this._productgroupdiscounts.getView(), { top: 0, left: 250 } );

                let generaldiscounts = new venditabant.sales.customers.views.GeneralDiscounts();
                this._generaldiscounts = generaldiscounts;
                page4.add ( generaldiscounts.getView(), { top: 0, left: 490 } );

                return page4;
            },
            setCustomersFkey:function(customers_fkey) {
                this.clearScreen();
                this._customers_fkey = customers_fkey;
                this._stockitemdiscounts.setCustomersFkey(customers_fkey);
                this._productgroupdiscounts.setCustomersFkey(customers_fkey);
                this._generaldiscounts.setCustomersFkey(customers_fkey);
            },
            clearScreen:function() {

            },
        }
    });