qx.Class.define("venditabant.sales.invoices.models.Invoices",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            _address: new venditabant.application.Const().venditabant_endpoint(),
            add:function(cb, ctx, data) {
                let post = new venditabant.communication.Post;
                post.send(this._address, "api/v1/salesorders/save/", data,function(response){
                    cb.call ( ctx, (response));
                },this)
            },
            close:function(cb, ctx, data){
                let post = new venditabant.communication.Get();
                post.send(this._address, "api/v1/salesorders/close/", data,function(response){
                    cb.call ( ctx, (response));
                },this)
            },
            loadInvoiceList:function(cb, ctx, data) {
                let get = new venditabant.communication.Get;
                let open = data ? 1 : 0;
                get.load(this._address, "/api/v1/invoices/load_invoice_list/", open, function(response){
                    cb.call ( ctx,(response));
                },this);
            },
            loadInvoice:function(cb, ctx, salesorders_pkey) {
                let get = new venditabant.communication.Get;
                salesorders_pkey = salesorders_pkey ? salesorders_pkey : 0;
                get.load(this._address, "/api/v1/salesorders/load_salesorder/", salesorders_pkey, function(response){
                    cb.call ( ctx,(response));
                },this);
            }
        }
    });