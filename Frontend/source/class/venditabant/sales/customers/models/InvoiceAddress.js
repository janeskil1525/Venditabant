

qx.Class.define("venditabant.sales.customers.models.InvoiceAddress",
    {
        extend: qx.core.Object,
        include:[qx.locale.MTranslation],
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            _address: new venditabant.application.Const().venditabant_endpoint(),
            load_invoice_address:function(cb, ctx, customers_fkey) {
                let get = new venditabant.communication.Get;
                get.load(this._address, "/api/v1/customers/invoice/address/load/", customers_fkey,function(response){
                    cb.call ( ctx,(response));
                },this);
            },
            saveInvoiceAddress:function(data, cb, ctx) {
                let com = new venditabant.communication.Post();
                com.send(this._address, "/api/v1/customers/invoice/address/save/", data, function (success) {
                    let win = null;
                    if (success.status === "success") {
                        cb.call(ctx,(success));
                    } else {
                        alert(this.tr('Could not save customer address, please try again'));
                    }
                }, this);
            },
        }
    });