/* ************************************************************************

   Copyright:

   License:

   Authors:

************************************************************************ */

/**
 * TODO: needs documentation
 */
qx.Class.define("delivery.page.Login",
{
  extend : qx.ui.mobile.page.NavigationPage,

  construct : function()
  {
    this.base(arguments);
    this.setTitle("Login");
  },


  members :
  {
    __form: null,


    // overridden
    _initialize: function() {
      this.base(arguments);

      // Username
      var name = new qx.ui.mobile.form.TextField();
      name.setRequired(true);
      this._name = name;

      // Password
      var pass = new qx.ui.mobile.form.PasswordField();
      pass.setRequired(true);
      this._pass = pass;

      // Login Button
      var loginButton = new qx.ui.mobile.form.Button("Login");
      loginButton.addListener("tap", this.login, this);

      var loginForm = this.__form = new qx.ui.mobile.form.Form();
      loginForm.add(name, "Username");
      loginForm.add(pass, "Password");

      // Use form renderer
      this.getContent().add(new qx.ui.mobile.form.renderer.Single(loginForm));
      this.getContent().add(loginButton);
    },
    login : function ( )  {
      let name = this._name.getValue ( );
      let pass = this._pass.getValue ( );
      if (!this.__form.validate()) {
        return;
      }
      if ( name.length < 1 || pass.length < 1 )  {
        alert ( this.tr ( "Please provide username and password" ) );
        return;
      }

      let app = new delivery.communication.Post ( );
      let data = {
        username:name, password:pass
      };
      app.send ( "http://192.168.1.134/", "api/login/", data, function ( success, rsp ) {
        if (success) {
          let jwt = new qx.data.store.Offline('userid','local');
          jwt.setModel(qx.data.marshal.Json.createModel(rsp.data));
          qx.core.Init.getApplication().getRouting().executeGet("/overview");
        } else {
          alert(this.tr("Could not log in."));
        }
      }, this );

    },
    /**
     * Event handler for <code>tap</code> on the login button.
     */
    _onButtonTap: function() {
      // use form validation
      if (this.__form.validate()) {
        qx.core.Init.getApplication().getRouting().executeGet("/overview");
      }
    }
  }

});
