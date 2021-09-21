
qx.Class.define("venditabant.users.management.models.Users",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            loadList:function(cb, ctx) {
                let get = new venditabant.communication.Get;
                get.load("http://192.168.1.134/", "api/v1/users/load_list/", '',function(response){
                    cb.call ( ctx,(response));
                },this);
            },
            saveUser:function(data, cb, ctx) {
                let com = new venditabant.communication.Post();
                com.send("http://192.168.1.134/", "api/v1/users/save/", data, function (success) {
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