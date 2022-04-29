

qx.Class.define("venditabant.cockpit.models.AutoTodos",
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
                get.load(this._address, "/api/v1/autotodos/load_list/", '',function(response){
                    cb.call ( ctx,(response));
                },this);
            },
            saveCustomer:function(data, cb, ctx) {
                let com = new venditabant.communication.Post();
                com.send(this._address, "/api/v1/autotodos/save/", data, function (success) {
                    let win = null;
                    if (success) {
                        cb.call(ctx,(data));
                    } else {
                        alert(this.tr('Could not save autotodo, please try again'));
                    }
                }, this);
            },
            run_checkpoints:function(cb, ctx) {
                let com = new venditabant.communication.Get();
                com.load(this._address, "/api/v1/autotodos/run_checkpoints/",'',function (success) {
                    let win = null;
                    if (success) {
                        cb.call(ctx);
                    } else {
                        alert(this.tr('Could not run checkpoints, please try again'));
                    }
                }, this);
            }
        }
    });