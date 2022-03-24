/* ************************************************************************

   Copyright: 2021 undefined

   License: MIT license

   Authors: undefined

************************************************************************ */

/**
 * This is the main application class of "venditabant"
 *
 * @asset(venditabant/*)
 */
qx.Class.define("venditabant.Application",
{
  extend : qx.application.Standalone,



  /*
  *****************************************************************************
     MEMBERS
  *****************************************************************************
  */

  members :
  {
      _address: new venditabant.application.Const().venditabant_endpoint(),
    main : function ( )  {
      this.base ( arguments );
      if ( qx.core.Environment.get ( "qx.debug" ) )  {
        qx.log.appender.Native;
        qx.log.appender.Console;
      }
      let root = this.getRoot ( );
      let decorator = new qx.ui.decoration.Decorator ( );
      let adress = new venditabant.application.Const()
      decorator.setBackgroundImage ( this._address + ":30001/kaffebonor-fotona.jpg" );
      decorator.setBackgroundRepeat( "scale" );

      this.getRoot ( ).setDecorator( decorator );
        let jwt = new qx.data.store.Offline('userid','local');
        let jwt_model = jwt.getModel();
        let win;
        if(typeof jwt_model === 'undefined' || jwt_model === null) {
            win = new venditabant.users.login.LoginWindow ( );
            win.show ( );
        } else {
            if(typeof jwt_model.getUserid === 'function' && jwt_model.getUserid() !== '') {
                win = new venditabant.application.ApplicationWindow();
                win.set({
                    support:true
                });
                win.show();
            } else {
                win = new venditabant.users.login.LoginWindow ( );
                win.show ( );
            }
        }



      /*this.rpc ( "type=check", function ( success )  {
        var win = null;
        if ( success )
          win = new venditabant.application.ApplicationWindow ( );
        else
          win = new venditabant.users.login.LoginWindow ( );
        win.show ( );
      },this );*/
    },
    rpc : function ( str, cb, ctx )  {
     let rpc = new qx.io.request.Xhr ( "_address/api/v1/login");
     rpc.setMethod("POST");
     rpc.setRequestHeader("Access-Control-Allow-Origin");
        //rpc.setRequestHeader("content-type","application/json");

     //rpc.requestHeaders("Access-Control-Allow-Origin");
      rpc.setRequestData({username:"janeskil", password:"Kalle"});
      rpc.addListener ( "success", function ( e, x, y ) {
        var req = e.getTarget ( );
        var rsp = req.getResponse ( );
        //var model = qx.data.marshal.Json.createModel({rsp});
        //let result = model.login;
        cb.call ( ctx, ( rsp.login === "success" ) );
      }, this );
      rpc.send ( );
    },
      mode: function() {
        return 'test';
    },

  }
});
