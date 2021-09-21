qx.Class.define("desktop_delivery.utils.UserJwt",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members:{
            getUserJwt:function(){
                let user_jwt = '';
                let jwt = new qx.data.store.Offline('userid','local');
                let jwt_model = jwt.getModel();
                if(typeof jwt_model !== 'undefined' &&
                    jwt_model !== null &&
                    typeof jwt_model.getJwt === "function") {

                    user_jwt = jwt_model.getJwt();
                }
                return user_jwt;
            }
        }
    });