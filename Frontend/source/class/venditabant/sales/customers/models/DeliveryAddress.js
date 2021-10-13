

qx.Class.define("venditabant.sales.customers.models.DeliveryAddress",
    {
        extend: qx.core.Object,
        include:[qx.locale.MTranslation],
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            _address: new venditabant.application.Const().venditabant_endpoint(),
            loadDeliveryAddress:function(cb, ctx, customer_addresses_pkey) {
                let get = new venditabant.communication.Get;
                get.load(this._address, "/api/v1/customers/delivery/address/load/", customer_addresses_pkey,function(response){
                    cb.call ( ctx,(response));
                },this);
            },
            loadDeliveryAddressList:function(cb, ctx, customers_fkey) {
                let get = new venditabant.communication.Get;
                get.load(this._address, "/api/v1/customers/delivery/address/load_list/", customers_fkey,function(response){
                    cb.call ( ctx,(response));
                },this);
            },
            saveDeliveryAddress:function(data, cb, ctx) {
                let com = new venditabant.communication.Post();
                com.send(this._address, "/api/v1/customers/delivery/address/save/", data, function (success) {
                    let win = null;
                    if (success.status === "success") {
                        cb.call(ctx,(success));
                    } else {
                        alert(this.tr('Could not save customer address, please try again'));
                    }
                }, this);
            },
        }
    });