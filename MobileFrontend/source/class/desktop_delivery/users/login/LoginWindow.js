qx.Class.define ( "desktop_delivery.users.login.LoginWindow",
    {
        extend : qx.ui.container.Composite,
        construct : function ( ) {
            this.base ( arguments );
            this.setLayout ( new qx.ui.layout.Canvas ( ) );
            this.set ( { width: 300, height: 200 } );
            this._buildLogin ( );
            var top  = parseInt ( ( qx.bom.Document.getHeight ( ) - 200 ) / 2, 10 );
            var left = parseInt ( ( qx.bom.Document.getWidth  ( ) - 300 ) / 2, 10 );
            var app  = qx.core.Init.getApplication ( );
            var root = app.getRoot( );
            root.add ( this, { top: top, left: left } );
        },
        destruct : function ( )  {
        },
        members  :  {
            _buildLogin : function ( )  {
                var semi = new qx.ui.core.Widget ( );
                semi.set ( { opacity: 0.6, backgroundColor: "#404040" } );
                this.add ( semi, { top: 1, left: 1, right: 1, bottom: 1 } );

                var font = new qx.bom.Font ( 24, [ "Arial" ] );
                font.setBold ( true );
                //font.setColor ( "#FFFFFF" );
                var lbl = new qx.ui.basic.Label ( "<center><b style='color: #FFFFFF'>" + this.tr ( "Log in" ) + "</b></center>" );
                lbl.setFont ( font );
                lbl.setRich ( true );
                lbl.setWidth( this.getWidth ( ) - 20  );
                this.add ( lbl, { top: 10, left: 10 } );

                var line = new qx.ui.core.Widget ( );
                line.set ( { height: 2, backgroundColor: '#FFFFFF' } );
                this.add ( line, { top: 50, left: 10, right: 10 } );

                var name = new qx.ui.form.TextField ( );
                name.setPlaceholder ( this.tr ( "Email" ) );
                this.add ( name, { top: 65, left: 10, right: 10 } );
                this._name = name;

                var pass = new qx.ui.form.PasswordField ( );
                pass.setPlaceholder ( this.tr ( "Password" ) );
                this.add ( pass, { top: 100, left: 10, right: 10 } );
                this._pass = pass;

                var chk = new qx.ui.form.CheckBox ( "<b style='color: #FFFFFF'>" + this.tr ( "Remember me ?" ) + "</b>" );
                lbl = chk.getChildControl ( "label" );
                lbl.setRich ( true );
                this.add ( chk, { top: 130, left: 10 } );
                this._remember = chk;

                var strForgot = "<center><i style='color: white'>" + this.tr ( "Forgot Password ?" ) + "</i></center>";
                var btnForgot = new qx.ui.basic.Atom ( strForgot );
                btnForgot.set ( { cursor: 'pointer' } );
                lbl = btnForgot.getChildControl ( "label" );
                lbl.setRich ( true );
                lbl.setAllowGrowY ( true );
                btnForgot.addListener( "mouseover", function ( )  {
                    btnForgot.setLabel ( "<u style='color: white'>" + strForgot + "</u>" );
                },this );
                btnForgot.addListener( "mouseout", function ( )  {
                    btnForgot.setLabel ( strForgot );
                },this );
                btnForgot.addListener( "click", function ( )  {
                    // this.forgot ( );
                },this );
                this.add ( btnForgot, { top: 130, right: 10 } );

                var width = parseInt ( ( this.getWidth ( ) - 30 ) / 2, 10 );
                var btnLogin = this._createBtn ( this.tr ( "Log in" ), "#AAAAFF70", width, function ( ) {
                    this.login ( );
                }, this );
                this.add ( btnLogin, { bottom: 10, left: 10 } );
            },
            _createBtn : function ( txt, clr, width, cb, ctx )  {

                let btn = new desktop_delivery.widget.button.Standard().createBtn(txt, clr, width, cb, ctx)

                return btn;
            },
            forgot : function ( )  {
                /*var forgot = new desktop_delivery.users.login.ForgotWindow ( );
                forgot.show  ( );
                this.destroy ( );*/
            },
            login : function ( )  {
                var name = this._name.getValue ( );
                var pass = this._pass.getValue ( );
                var remember = this._remember.getValue ( );
                if ( name.length < 1 || pass.length < 1 )  {
                    alert ( this.tr ( "Please provide username and password" ) );
                    return;
                }

                let app = new desktop_delivery.communication.Post ( );
                let data = {
                    username:name, password:pass
                };
                app.send ( "http://192.168.1.134/", "api/login/", data, function ( success, rsp ) {
                    if (success) {
                        let jwt = new qx.data.store.Offline('userid','local');
                        jwt.setModel(qx.data.marshal.Json.createModel(rsp.data));

                        let win = new desktop_delivery.delivery.DeliveryWindow();
                        win.show();
                        this.destroy();
                    } else {
                        alert(this.tr("Could not log in."));
                    }
                }, this );

            },
            signup : function ( )  {
                /*var signup = new desktop_delivery.users.login.SignupWindow ( );
                signup.show  ( );
                this.destroy ( );*/
            },
        }
    } );
