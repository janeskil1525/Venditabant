

qx.Class.define("venditabant.sales.customers.models.GeneralDiscounts",
    {
        extend: qx.core.Object,
        include:[qx.locale.MTranslation],
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            _address: new venditabant.application.Const().venditabant_endpoint(),
            loadList:function(cb, ctx, customers_fkey) {
                let get = new venditabant.communication.Get;
                get.load(this._address, "/api/v1/discounts/general/load_list/", customers_fkey,function(response){
                    cb.call ( ctx,(response));
                },this);
            },
            saveGeneralDiscount:function(data, cb, ctx) {
                let com = new venditabant.communication.Post();
                com.send(this._address, "/api/v1/discounts/general/save/", data, function (success) {
                    let win = null;
                    if (success === 'success') {
                        cb.call(ctx,(success));
                    } else {
                        alert(this.tr('Could not save discount, please try again'));
                    }
                }, this);
            },
            deleteGeneralDiscount:function(customer_discount_pkey, customers_fkey, cb, ctx) {
                let get = new venditabant.communication.Get;
                let argument = customer_discount_pkey + "/" + customers_fkey
                get.load(this._address, "/api/v1/discounts/general/delete/", argument,function(response){
                    cb.call ( ctx,(response));
                },this);
            }
        }
    });