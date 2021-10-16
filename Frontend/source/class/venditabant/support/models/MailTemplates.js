

qx.Class.define("venditabant.support.models.MailTemplates",
    {
        extend: qx.core.Object,
        include: [qx.locale.MTranslation],
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            _address: new venditabant.application.Const().venditabant_endpoint(),
            loadList:function(cb, ctx) {
                let get = new venditabant.communication.Get;
                get.load(this._address, "/api/v1/mailtemplates/load_list/", '',function(response){
                    cb.call ( ctx, (response));
                },this)

            },
            saveSentinel:function(data, cb, ctx) {
                let com = new venditabant.communication.Post();
                com.send(this._address, "/api/v1/mailtemplates/save/", data, function (success) {
                    if (success) {
                        cb.call(ctx,(data));
                    } else {
                        alert(this.tr('success'));
                    }
                }, this);
            }
        }
    });