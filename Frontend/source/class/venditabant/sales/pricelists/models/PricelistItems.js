

qx.Class.define("venditabant.sales.pricelists.models.PricelistItems",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            _address: new venditabant.application.Const().venditabant_endpoint(),
            loadList:function(cb, ctx, data) {
                let get = new venditabant.communication.Get;
                get.load(this._address, "/api/v1/pricelists/items/load_list/", data,function(response){
                    cb.call ( ctx,(response));
                },this);
            },
            savePricelistItem:function(data, cb, ctx) {
                let com = new venditabant.communication.Post();
                com.send(this._address, "/api/v1/pricelists/items/save/", data, function (success) {
                    cb.call(ctx,(success));
                }, this);
            },
        }
    });