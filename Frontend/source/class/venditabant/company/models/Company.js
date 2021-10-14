

qx.Class.define("venditabant.company.models.Company",
    {
        extend: qx.core.Object,
        include:[qx.locale.MTranslation],
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            _address: new venditabant.application.Const().venditabant_endpoint(),
            loadList:function(cb, ctx) {
                let get = new venditabant.communication.Get;
                get.load(this._address, "/api/v1/company/load_list/", '',function(response){
                    cb.call ( ctx,(response));
                },this);
            },
            loadCompany:function(cb, ctx) {
                let get = new venditabant.communication.Get;
                get.load(this._address, "/api/v1/company/load/", '',function(response){
                    cb.call ( ctx,(response));
                },this);
            },
            saveCompany:function(data, cb, ctx) {
                let com = new venditabant.communication.Post();
                com.send(this._address, "/api/v1/company/save/", data, function (success) {
                    if (success) {
                        cb.call(ctx,(data));
                    } else {
                        alert(this.tr('Could not save company, please try again'));
                    }
                }, this);
            },
        }
    });