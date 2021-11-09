
qx.Class.define("desktop_delivery.models.Deliveryaddresses",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            _address: new desktop_delivery.utils.Const().venditabant_endpoint(),
            loadList:function(cb, ctx, customer) {
                let get = new desktop_delivery.communication.Get;
                get.load(this._address, "/api/v1/customers/delivery/address/load_list_customer/", customer, function(response){
                    cb.call ( ctx,(response));
                },this);
            },
            loadListDeliveryAddressListFromCompany:function(cb, ctx) {
                let get = new desktop_delivery.communication.Get;
                get.load(this._address, "/api/v1/customers/delivery/address/load_list_company/", '', function(response){
                    cb.call ( ctx,(response));
                },this);
            },
            loadDeliveryAddressList:function(cb, ctx, customers_fkey) {
                let get = new desktop_delivery.communication.Get;
                get.load(this._address, "/api/v1/customers/delivery/address/load_list/", customers_fkey, function (response) {
                    cb.call(ctx, (response));
                }, this);
            }
        }
    });