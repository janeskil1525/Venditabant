qx.Class.define("desktop_delivery.models.Salesorders",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            add:function(cb, ctx, data) {
                let post = new desktop_delivery.communication.Post;
                post.send("http://192.168.1.134/", "api/v1/salesorders/save/", data,function(response){
                    cb.call ( ctx, (response));
                },this)
            },
            close:function(cb, ctx, data){
                let post = new desktop_delivery.communication.Post;
                post.send("http://192.168.1.134/", "api/v1/salesorders/close/", data,function(response){
                    cb.call ( ctx, (response));
                },this)
            }
        }
    });