

qx.Class.define("venditabant.stock.stockitems.models.Stockitem",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            loadList:function(cb, ctx) {
                let get = new venditabant.communication.Get;
                get.load("http://192.168.1.134/", "api/v1/stockitem/load_list/", '',function(response, rsp){
                    cb.call ( ctx, (response, rsp) );
                },this)

            }
        }
    });