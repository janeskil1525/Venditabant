qx.Class.define("desktop_delivery.models.Stockitems",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members: {

            _address: new desktop_delivery.utils.Const().venditabant_endpoint(),
            loadList:function(cb, ctx) {
                let get = new desktop_delivery.communication.Get;
                get.load(this._address, "/api/v1/stockitem/load_list/", '',function(response){
                    cb.call ( ctx, (response));
                },this)
            },
            loadListSales:function(cb, ctx, customer_addresses_pkey) {
                let get = new desktop_delivery.communication.Get;
                get.load(this._address, "/api/v1/stockitem/load_list/mobile/", customer_addresses_pkey,function(response){
                    cb.call ( ctx, (response));
                },this)
            }
        }
    });