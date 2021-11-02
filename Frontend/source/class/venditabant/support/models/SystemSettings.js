

qx.Class.define("venditabant.support.models.SystemSettings",
    {
        extend: qx.core.Object,
        include: [qx.locale.MTranslation],
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            _address: new venditabant.application.Const().venditabant_endpoint(),
            load:function(cb, ctx, setting) {
                let get = new venditabant.communication.Get;
                get.load(this._address, "/api/v1/systemsettings/load/", setting,function(response){
                    cb.call ( ctx, (response));
                },this)

            },
            saveSystemSetting:function(data, cb, ctx) {
                let com = new venditabant.communication.Post();
                com.send(this._address, "/api/v1/systemsettings/save/", data, function (success) {
                    cb.call ( ctx, (success));
                }, this);
            }
        }
    });