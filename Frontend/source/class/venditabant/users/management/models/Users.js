
qx.Class.define("venditabant.users.management.models.Users",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        properties : {
            support : { nullable : true, check: "Boolean" }
        },
        members: {
            _address: new venditabant.application.Const().venditabant_endpoint(),
            loadList:function(cb, ctx) {
                let get = new venditabant.communication.Get;
                let endpoint = "/api/v1/v_users_companies_fkey/list/";
                if(this.isSupport() === true) {
                    endpoint = "/api/v1/v_users_support/list/";
                }
                get.load(this._address, endpoint, '',function(response){
                    cb.call ( ctx,(response));
                },this);
            },
            saveUser:function(data, cb, ctx) {
                let com = new venditabant.communication.Post();
                com.send(this._address, "/api/v1/users/update_user/", data, function (success) {
                    let win = null;
                    if (success) {
                        cb.call(ctx,(data));
                    } else {
                        alert(this.tr('success'));
                    }
                }, this);
            },
            createUser:function(data, cb, ctx) {
                let com = new venditabant.communication.Post();
                com.send(this._address, "/api/v1/users/create_user/", data, function (success) {
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