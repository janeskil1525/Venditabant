
qx.Class.define("venditabant.users.management.models.Users",
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
                let endpoint = "/api/v1/users/load_list/";
                if(ctx.isSupport() === true) {
                    endpoint = "/api/v1/users/load_list/support/";
                }
                get.load(this._address, "/api/v1/users/load_list/", '',function(response){
                    cb.call ( ctx,(response));
                },this);
            },
            saveUser:function(data, cb, ctx) {
                let com = new venditabant.communication.Post();
                com.send(this._address, "/api/v1/users/save/", data, function (success) {
                    let win = null;
                    if (success) {
                        cb.call(ctx,(data));
                    } else {
                        alert(this.tr('success'));
                    }
                }, this);
            },
        }
    });