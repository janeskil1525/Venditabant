qx.Class.define("delivery.models.Stockitems",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            loadList:function(cb, ctx) {
                let get = new delivery.communication.Get;
                get.load("http://192.168.1.134/", "api/v1/stockitem/load_list/", '',function(response){
                    cb.call ( ctx, (response));
                },this)

            }
        }
    });