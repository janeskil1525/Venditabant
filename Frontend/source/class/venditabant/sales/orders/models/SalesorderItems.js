qx.Class.define("venditabant.sales.orders.models.SalesorderItems",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            _address: new venditabant.application.Const().venditabant_endpoint(),
            loadSalesorderItemsList:function(cb, ctx, salesorders_fkey) {
                let get = new venditabant.communication.Get;
                salesorders_fkey = salesorders_fkey ? salesorders_fkey : 0;
                get.load(this._address, "/api/v1/salesorders/items/load_list/", salesorders_fkey, function(response){
                    cb.call ( ctx,(response));
                },this);
            },
            saveOrderItem:function(data, cb, ctx) {
                let com = new venditabant.communication.Post();
                com.send(this._address, "/api/v1/salesorders/items/save/", data, function (success) {
                    cb.call(ctx,(success));
                }, this);
            },
        }
    });