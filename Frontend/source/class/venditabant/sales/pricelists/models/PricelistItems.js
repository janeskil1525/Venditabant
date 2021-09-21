

qx.Class.define("venditabant.sales.pricelists.models.PricelistItems",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            loadList:function(cb, ctx, data) {
                let get = new venditabant.communication.Get;
                get.load("http://192.168.1.134/", "api/v1/pricelists/items/load_list/", data,function(response){
                    cb.call ( ctx,(response));
                },this);
            },
            savePricelistItem:function(data, cb, ctx) {
                let com = new venditabant.communication.Post();
                com.send("http://192.168.1.134/", "api/v1/pricelists/items/save/", data, function (success) {
                    cb.call(ctx,(success));
                }, this);
            },
        }
    });