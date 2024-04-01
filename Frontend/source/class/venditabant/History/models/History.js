

qx.Class.define("venditabant.History.models.History",
    {
        extend: qx.core.Object,
        include:[qx.locale.MTranslation],
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            _address: new venditabant.application.Const().venditabant_endpoint(),
            loadList:function(data,cb, ctx) {
                let get = new venditabant.communication.Get;
                get.load(this._address, "/api/v1/workflows/history/load/"  + data.type + "/" + data.key, '',function(response){
                    cb.call ( ctx,(response));
                },this);
            },
        }
    });