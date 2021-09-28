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
                post.send(_address, "api/v1/salesorders/save/", data,function(response){
                    cb.call ( ctx, (response));
                },this)
            },
            close:function(cb, ctx, data){
                let post = new venditabant.communication.Get();
                post.send(_address, "api/v1/salesorders/close/", data,function(response){
                    cb.call ( ctx, (response));
                },this)
            }
        }
    });