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
            loadListSales:function(cb, ctx, customer_model) {
                let get = new desktop_delivery.communication.Get;
                let condition = customer_model.customers_fkey + '/' + customer_model.customer_addresses_pkey;
                get.load(this._address, "/api/v1/mobilelist/load_list/", condition,function(response){
                    cb.call ( ctx, (response));
                },this)
            }
        }
    });