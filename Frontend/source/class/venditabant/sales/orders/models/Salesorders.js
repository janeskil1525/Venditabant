qx.Class.define("venditabant.sales.orders.models.Salesorders",
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
            loadSalesorderList:function(cb, ctx, data) {
                let get = new venditabant.communication.Get;
                let open = data ? 1 : 0;
                get.load(this._address, "/api/v1/salesorders/load_salesorder_list/", open, function(response){
                    cb.call ( ctx,(response));
                },this);
            },
            loadSalesorder:function(cb, ctx, salesorders_pkey) {
                let get = new venditabant.communication.Get;
                salesorders_pkey = salesorders_pkey ? salesorders_pkey : 0;
                get.load(this._address, "/api/v1/salesorders/load_salesorder/", salesorders_pkey, function(response){
                    cb.call ( ctx,(response));
                },this);
            }
        }
    });