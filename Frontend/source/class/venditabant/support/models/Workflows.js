

qx.Class.define("venditabant.support.models.Workflows",
    {
        extend: qx.core.Object,
        include: [qx.locale.MTranslation],
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            _address: new venditabant.application.Const().venditabant_endpoint(),
            export:function(cb, ctx) {
                let get = new venditabant.communication.Get;
                get.load(this._address, "/api/v1/workflows/export/", '',function(response){
                    cb.call ( ctx, (response));
                },this)
            },
            loadList:function(cb, ctx) {
                let get = new venditabant.communication.Get;
                get.load(this._address, "/api/v1/workflows/load_list/", '',function(response){
                    cb.call ( ctx, (response));
                },this)
            },
            load:function(cb, ctx, workflows_pkey, workflow_type) {
                let get = new venditabant.communication.Get;
                let condition = workflows_pkey + '/' + workflow_type;
                get.load(this._address, "/api/v1/workflows/load/", condition,function(response){
                    cb.call ( ctx, (response));
                },this)
            },
            save:function(data, cb, ctx) {
                let com = new venditabant.communication.Put();
                com.send(this._address, "/api/v1/workflows/save/", data, function (success) {
                    cb.call ( ctx, (success));
                }, this);
            }
        }
    });