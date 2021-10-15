


qx.Class.define("venditabant.support.models.Languages",
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
                get.load(this._address, "/api/v1/languages/load_list/", '',function(response){
                    cb.call ( ctx, (response));
                },this)

            }
        }
    });