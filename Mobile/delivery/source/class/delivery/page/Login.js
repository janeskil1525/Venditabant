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
      var user = new qx.ui.mobile.form.TextField();
      user.setRequired(true);

      // Password
      var pwd = new qx.ui.mobile.form.PasswordField();
      pwd.setRequired(true);

      // Login Button
      var loginButton = new qx.ui.mobile.form.Button("Login");
      loginButton.addListener("tap", this.login, this);

      var loginForm = this.__form = new qx.ui.mobile.form.Form();
      loginForm.add(user, "Username");
      loginForm.add(pwd, "Password");

      // Use form renderer
      this.getContent().add(new qx.ui.mobile.form.renderer.Single(loginForm));
      this.getContent().add(loginButton);
    },
    login : function ( )  {
      let name = this.name.getValue ( );
      let pwd = this.pwd.getValue ( );
      if (!this.__form.validate()) {
        return;
      }
      if ( name.length < 1 || pwd.length < 1 )  {
        alert ( this.tr ( "Please provide username and password" ) );
        return;
      }

      let app = new delivery.communication.Post ( );
      let data = {
        username:name, password:pwd
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
