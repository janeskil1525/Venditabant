qx.Class.define("venditabant.sales.invoices.models.InvoiceItems",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            _address: new venditabant.application.Const().venditabant_endpoint(),
            loadInvoiceItemsList:function(cb, ctx, invoice_fkey) {
                let get = new venditabant.communication.Get;
                invoice_fkey = invoice_fkey ? invoice_fkey : 0;
                get.load(this._address, "/api/v1/invoices/items/load_list/", invoice_fkey, function(response){
                    cb.call ( ctx,(response));
                },this);
            },
            saveOrderItem:function(data, cb, ctx) {
                let com = new venditabant.communication.Post();
                com.send(this._address, "/api/v1/invoices/items/save/", data, function (success) {
                    cb.call(ctx,(success));
                }, this);
            },
        }
    });