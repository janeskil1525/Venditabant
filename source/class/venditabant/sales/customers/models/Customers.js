

qx.Class.define("venditabant.sales.customers.models.Customers",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            loadList:function(cb, ctx) {
                let get = new venditabant.communication.Get;
                get.load("http://192.168.1.134/", "api/v1/customers/load_list/", '',function(response){
                    cb.call ( ctx,(response));
                },this);
            },
            savePricelistHead:function(data, cb, ctx) {
                let com = new venditabant.communication.Post();
                com.send("http://192.168.1.134/", "api/v1/customers/save/", data, function (success) {
                    let win = null;
                    if (success) {
                        cb.call(ctx,(data));
                    } else {
                        alert(this.tr('success'));
                    }
                }, this);
            },
        }
    });