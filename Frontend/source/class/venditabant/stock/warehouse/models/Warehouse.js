qx.Class.define("venditabant.stock.warehouse.models.Warehouse",
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
                get.load(this._address, "/api/v1/warehouses/load_list/", '',function(response){
                    cb.call ( ctx, (response));
                },this)

            },
            saveWarehouse:function(cb, ctx,data) {
                let get = new venditabant.communication.Post ( );
                get.send ( this._address, "/api/v1/warehouses/save/", data, function ( success ) {
                    cb.call ( ctx, (success));
                }, this );

            },
        }
    });