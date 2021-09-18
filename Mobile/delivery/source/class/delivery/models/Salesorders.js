qx.Class.define("venditabant.stock.stockitems.models.Salesorders",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            add:function(cb, ctx, data) {
                let post = new venditabant.communication.Post;
                post.send("http://192.168.1.134/", "api/v1/salesorders/add/", data,function(response){
                    cb.call ( ctx, (response));
                },this)

            }
        }
    });