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
    main : function ( )  {
      this.base ( arguments );
      if ( qx.core.Environment.get ( "qx.debug" ) )  {
        qx.log.appender.Native;
        qx.log.appender.Console;
      }
      let root = this.getRoot ( );
      let decorator = new qx.ui.decoration.Decorator ( );
      decorator.setBackgroundImage ( "http://localhost:3000/background.jpg" );
      decorator.setBackgroundRepeat( "scale" );
      this.getRoot ( ).setDecorator( decorator );
      let win = new venditabant.users.login.LoginWindow ( );
      win.show ( );
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
     let rpc = new qx.io.request.Xhr ( "http://localhost:3000/v1/login","POST" );
     rpc.setMethod("POST");
     rpc.setRequestHeader("Access-Control-Allow-Origin");
        rpc.setRequestHeader("content-type","application/json");

     //rpc.requestHeaders("Access-Control-Allow-Origin");
      rpc.setRequestData({username:"janeskil", password:"Kalle"});
      rpc.addListener ( "success", function ( e, x, y ) {
        var req = e.getTarget ( );
        var rsp = req.getResponse ( );
        cb.call ( ctx, ( rsp === "true" ) );
      }, this );
      rpc.send ( );
    }
  }
});
