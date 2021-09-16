/* ************************************************************************

   Copyright: 2021 undefined

   License: MIT license

   Authors: undefined

************************************************************************ */

/**
 * This is the main application class of your custom application "${Name}"
 *
 * @asset(delivery/*)
 */
qx.Class.define("delivery.Application",
{
  extend : qx.application.Mobile,


  members :
  {

    /**
     * This method contains the initial application code and gets called
     * during startup of the application
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
        // support additional cross-browser console.
        // Trigger a "longtap" event on the navigation bar for opening it.
        qx.log.appender.Console;
      }

      /*
      -------------------------------------------------------------------------
        Below is your actual application code...
        Remove or edit the following code to create your application.
      -------------------------------------------------------------------------
      */

      var login = new delivery.page.Login();
      var overview = new delivery.page.Overview();

      // Add the pages to the page manager.
      var manager = new qx.ui.mobile.page.Manager(false);
      manager.addDetail([
        login,
        overview
      ]);

      // Initialize the application routing
      this.getRouting().onGet("/", this._show, login);
      this.getRouting().onGet("/overview", this._show, overview);

      this.getRouting().init();
    },


    /**
     * Default behaviour when a route matches. Displays the corresponding page on screen.
     * @param data {Map} the animation properties
     */
    _show : function(data) {
      this.show(data.customData);
    }
  }
});
