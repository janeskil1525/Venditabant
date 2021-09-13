qx.Class.define("venditabant.communication.Get",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members:{
            load:function(url, endpoint, data, cb, ctx){
                let address = url + endpoint + data;
                // "http://192.168.1.134/api/v1/save_stockitem"
                let rpc = new qx.io.request.Xhr (address);
                rpc.setMethod("GET");

                let jwt = new venditabant.utils.UserJwt();
                let user_jwt = jwt.getUserJwt();

                if(typeof user_jwt !== 'undefined' && user_jwt !== '') {
                    rpc.setRequestHeader( "X-Token-Check", user_jwt );
                }

                rpc.setRequestHeader( "Content-Type", "application/json" );
                rpc.addListener ( "success", function ( e, x, y ) {
                    var req = e.getTarget ( );
                    var rsp = req.getResponse ( );
                    cb.call ( ctx, ( rsp.result === "success" ), rsp );
                }, this );
                rpc.send ( );

            }
        }
    });