/* ************************************************************************

   Copyright: 2021 undefined

   License: MIT license

   Authors: undefined

************************************************************************ */

/**
 * This is the main application class of "desktop_delivery"
 *
 * @asset(desktop_delivery/*)
 */
qx.Class.define("desktop_delivery.Application",
{
  extend : qx.application.Standalone,



  /*
  *****************************************************************************
     MEMBERS
  *****************************************************************************
  */

  members :
  {
    /**
     * This method contains the initial application code and gets called 
     * during startup of the application
     * 
     * @lint ignoreDeprecated(alert)
     */
    main : function()
    {
      // Call super class
      this.base(arguments);

      // Enable logging in debug variant
      if (qx.core.Environment.get("qx.debug"))
      {
        // support native logging capabilities, e.g. Firebug for Firefox
        qx.log.appender.Native;
        // support additional cross-browser console. Press F7 to toggle visibility
        qx.log.appender.Console;
      }

      /*
      -------------------------------------------------------------------------
        Below is your actual application code...
      -------------------------------------------------------------------------
      */

      let root = this.getRoot ( );
      let decorator = new qx.ui.decoration.Decorator ( );
      decorator.setBackgroundImage ( "http://localhost:3000/kaffebonor-fotona.jpg" );
      decorator.setBackgroundRepeat( "scale" );

      this.getRoot ( ).setDecorator( decorator );
      let jwt = new qx.data.store.Offline('userid','local');
      let jwt_model = jwt.getModel();
      let win;
      if(typeof jwt_model === 'undefined' || jwt_model === null) {
        win = new desktop_delivery.users.login.LoginWindow ( );
        win.show ( );
      } else {
        if(typeof jwt_model.getUserid === 'function' && jwt_model.getUserid() !== '') {
          win = new desktop_delivery.delivery.DeliveryWindow();
          win.show();
        } else {
          win = new desktop_delivery.users.login.LoginWindow ( );
          win.show ( );
        }
      }
    }
  }
});