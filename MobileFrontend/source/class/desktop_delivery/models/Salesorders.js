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
            close:function(cb, ctx, data){
                let post = new desktop_delivery.communication.Post;
                post.send(this._address, "/api/v1/salesorders/close/", data,function(response){
                    cb.call ( ctx, (response));
                },this)
            },
            loadSalesorderKey:function(cb, ctx,data) {
                let post = new desktop_delivery.communication.Post;
                post.send(this._address, "/api/v1/salesorders/load_key/", data,function(response){
                    cb.call ( ctx,(response));
                },this);
            },
        }
    });