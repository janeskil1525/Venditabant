qx.Class.define("venditabant.communication.Get",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members:{
            load:function(url, endpoint, data, cb, ctx){
                let address = url + endpoint;
                if(typeof data !== 'undefined' && data !== null && data.length > 0) {
                    address = address + data;
                } else if (typeof data === 'number' ) {
                    address = address + data;
                }

                let rpc = new qx.io.request.Xhr (address);
                rpc.setMethod("GET");

                let jwt = new venditabant.utils.UserJwt();
                let user_jwt = jwt.getUserJwt();

                if(typeof user_jwt !== 'undefined' && user_jwt !== '') {
                    rpc.setRequestHeader( "X-Token-Check", user_jwt );
                }

                rpc.setRequestHeader( "Content-Type", "application/json" );
                rpc.addListener ( "success", function ( e, x, y ) {
                    let req = e.getTarget ( );
                    let rsp = req.getResponse ( );
                    cb.call ( ctx, (rsp));
                }, this );
                rpc.send ( );

            }
        }
    });