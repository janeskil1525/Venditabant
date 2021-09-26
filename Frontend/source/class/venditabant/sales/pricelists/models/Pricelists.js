

qx.Class.define("venditabant.sales.pricelists.models.Pricelists",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            _address: new venditabant.application.Const().venditabant_endpoint(),
            loadList:function(cb, ctx) {
                let get = new venditabant.communication.Get;
                get.load(this._address, "/api/v1/pricelists/heads/load_list/", '',function(response){
                    cb.call ( ctx,(response));
                },this);
            },
            savePricelistHead:function(data, cb, ctx) {
                let com = new venditabant.communication.Post();
                com.send(this._address, "/api/v1/pricelists/heads/save/", data, function (success) {
                    let win = null;
                    if (success) {
                        cb.call(ctx,(data.pricelist));
                    } else {
                        alert(this.tr('success'));
                    }
                }, this);
            },
        }
    });