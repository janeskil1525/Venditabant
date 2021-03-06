

qx.Class.define("venditabant.settings.models.Settings",
    {
        extend: qx.core.Object,
        include: [qx.locale.MTranslation],
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

            },
            saveSetting:function(data, cb, ctx) {
                let com = new venditabant.communication.Post();
                com.send(this._address, "/api/v1/parameters/save/", data, function (success) {
                    if (success) {
                        cb.call(ctx,(data));
                    } else {
                        alert(this.tr('success'));
                    }
                }, this);
            },
            deleteSetting:function(data, cb, ctx) {
                let com = new venditabant.communication.Post();
                com.send(this._address, "/api/v1/parameters/delete/", data, function (success) {
                    if (success) {
                        cb.call(ctx, (data));
                    } else {
                        alert(this.tr('success'));
                    }
                }, this);
            }
        }
    });