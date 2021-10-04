

qx.Class.define("venditabant.settings.models.Settings",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            _address: new venditabant.application.Const().venditabant_endpoint(),
            loadList:function(cb, ctx, setting) {
                let get = new venditabant.communication.Get;
                get.load(this._address, "/api/v1/parameters/load_list/", setting,function(response){
                    cb.call ( ctx, (response));
                },this)

            }
        }
    });