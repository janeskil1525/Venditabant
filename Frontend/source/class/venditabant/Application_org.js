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

      var label = new qx.ui.basic.Label();
      label.setValue("Regular");

      // Create a button
      var button1 = new qx.ui.form.Button("Click me", "venditabant/test.png");

      // Document is the application root
      var doc = this.getRoot();

      // Add button to document at fixed coordinates
      var toolbar = new qx.ui.toolbar.ToolBar();
      this.add(toolbar, { row: 0, column: 0 });
      doc.add(label, {left: 50, top: 50});
      doc.add(button1, {left: 100, top: 50});

      // Add an event listener
      button1.addListener("execute", function() {
        /* eslint no-alert: "off" */
        alert("Hello World!");
      });
    }
  }
});
