
qx.Class.define ( "venditabant.sales.invoices.views.Definition",
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

            setParams: function (params) {
            },
            getView: function () {
                let view = new qx.ui.container.Composite(new qx.ui.layout.Canvas());
                view.setBackgroundColor("white");

                /*var box = new qx.ui.container.Composite();
                box.setLayout(new qx.ui.layout.HBox(10));
                win.add(box, {flex: 1});*/
                var container = new qx.ui.container.Stack();
                container.setDecorator("main");
                this._container = container;

                let invoicelist = new venditabant.sales.invoices.views.InvoiceList().set({
                    support:this.isSupport(),
                    callback:this,
                });
                this._invoicelist = invoicelist;
                container.add(this._invoicelist.getView());
                // Add a TabView

                view.add(container, {top:5, left:5, right:5,height:"95%"});
                return view;

            },
            setInvoice:function(invoice_fkey) {
                if(typeof this._invoice=== 'undefined' || this._invoice === null) {
                    let invoice = new venditabant.sales.invoices.views.Invoice().set({
                        support:this.isSupport(),
                        invoice_fkey:invoice_fkey,
                        callback:this,
                    });
                    invoice.loadInvoice();
                    this._invoice = invoice;
                    this._container.add(this._invoice.getView());
                } else {
                    this._invoice.setInvoiceFkey(invoice_fkey);
                }
                this._invoice.loadInvoice();
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
