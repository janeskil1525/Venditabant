
qx.Class.define ( "venditabant.sales.orders.views.Definition",
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

            getView: function () {
                let that = this;

                let view = new qx.ui.container.Composite(new qx.ui.layout.Canvas());
                view.setBackgroundColor("white");

                var container = new qx.ui.container.Stack();
                container.setDecorator("main");
                this._container = container;

                let salesorderlist = new venditabant.sales.orders.views.SalesordersList().set({
                    support:this.isSupport(),
                    callback:this,
                });
                this._salesorderlist = salesorderlist;
                container.add(this._salesorderlist.getView());

                view.add(container, {top:5, left:5, right:5,height:"95%"});
                //this._tabView = tabView;
                return view;

            },
            setSalesorder:function(salesorders_fkey) {
                if(typeof this._salesorder === 'undefined' || this._salesorder === null) {
                    let salesorder = new venditabant.sales.orders.views.Salesorder().set({
                        support:this.isSupport(),
                        salesorders_fkey:salesorders_fkey,
                        callback:this,
                    });
                    salesorder.loadOrder();
                    this._salesorder = salesorder;
                    this._container.add(this._salesorder.getView());
                } else {
                    this._salesorder.setSalesorders_fkey(salesorders_fkey);
                }
                this._salesorder.loadOrder();
                this.nextViev();
            },
            nextViev: function() {
                this._container.next();
            },
            previousView:function() {
                this._container.previous();
            }

        }
    });
