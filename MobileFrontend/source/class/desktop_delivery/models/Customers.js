

qx.Class.define("desktop_delivery.models.Customers",
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
                get.load(this._address, "/api/v1/customers/load_list/", '',function(response){
                    cb.call ( ctx,(response));
                },this);
            },
        }
    });