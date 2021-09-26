

qx.Class.define("venditabant.stock.stockitems.models.Stockitem",
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
                get.load(this._address, "/api/v1/stockitem/load_list/", '',function(response){
                    cb.call ( ctx, (response));
                },this)

            }
        }
    });