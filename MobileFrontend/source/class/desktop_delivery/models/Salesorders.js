qx.Class.define("desktop_delivery.models.Salesorders",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            _address: new desktop_delivery.utils.Const().venditabant_endpoint(),
            add:function(cb, ctx, data) {
                let post = new desktop_delivery.communication.Post;
                post.send(this._address, "/api/v1/salesorders/save/", data,function(response){
                    cb.call ( ctx, (response));
                },this)
            },
            addItem:function(cb, ctx, data) {
                let post = new desktop_delivery.communication.Post;
                post.send(this._address, "/api/v1/salesorders/items/save_item/", data,function(response){
                    cb.call ( ctx, (response));
                },this)
            },
            close:function(cb, ctx, data){
                let post = new desktop_delivery.communication.Post;
                post.send(this._address, "/api/v1/salesorders/close/", data,function(response){
                    cb.call ( ctx, (response));
                },this)
            },
            loadSalesorderKey:function(cb, ctx,customer_addresses_pkey) {
                let get = new desktop_delivery.communication.Get;
                get.load(this._address, "/api/v1/salesorders/load_key/", customer_addresses_pkey,function(response){
                    cb.call ( ctx,(response));
                },this);
            },
        }
    });