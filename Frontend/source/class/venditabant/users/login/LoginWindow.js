
async function loadWindow(data) {
    let jwt = new qx.data.store.Offline('userid','local');
    jwt.setModel(qx.data.marshal.Json.createModel(data));
    await new Promise(resolve => setTimeout(resolve, 2000));
    return data;
}

qx.Class.define ( "venditabant.users.login.LoginWindow",
    {
        extend : qx.ui.container.Composite,
        construct : function ( ) {
            this.base ( arguments );
            this.setLayout ( new qx.ui.layout.Canvas ( ) );
            this.set ( { width: 500, height: 200 } );
            this._buildLogin ( );
            var top  = parseInt ( ( qx.bom.Document.getHeight ( ) - 200 ) / 2, 10 );
            var left = parseInt ( ( qx.bom.Document.getWidth  ( ) - 500 ) / 2, 10 );
            var app  = qx.core.Init.getApplication ( );
            var root = app.getRoot( );
            root.add ( this, { top: top, left: left } );
        },
        destruct : function ( )  {
        },
        members  :  {
            _address: new venditabant.application.Const().venditabant_endpoint(),
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

                let lbl1 = this._createLBL(this.tr ( "Email" ));
                this.add ( lbl1, { top: 65, left: 10 } );

                var name = new qx.ui.form.TextField ( );
                name.setPlaceholder ( this.tr ( "Email" ) );
                this.add ( name, { top: 65, left: 160, right: 10 } );
                this._name = name;

                lbl1 = this._createLBL(this.tr ( "Password" ));
                this.add ( lbl1, { top: 100, left: 10 } );

                var pass = new qx.ui.form.PasswordField ( );
                pass.setPlaceholder ( this.tr ( "Password" ) );
                this.add ( pass, { top: 100, left: 160, right: 10 } );
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
                    this.forgot ( );
                },this );
                this.add ( btnForgot, { top: 130, right: 10 } );

                var width = parseInt ( ( this.getWidth ( ) - 30 ) / 2, 10 );
                var btnLogin = this._createBtn ( this.tr ( "Log in" ), "#AAAAFF70", width, function ( ) {
                    this.login ( );
                }, this );
                this.add ( btnLogin, { bottom: 10, left: 10 } );
                var btnSignup = this._createBtn ( this.tr ( "Sign Up" ), "#AAFFAA70", width, function ( ) {
                    this.signup ( );
                }, this );
                this.add ( btnSignup, { bottom: 10, right: 10 } );

            },
            _createBtn : function ( txt, clr, width, cb, ctx )  {

                let btn = new venditabant.widget.button.Standard().createBtn(txt, clr, width, cb, ctx)

                return btn;
            },
            forgot : function ( )  {
                var forgot = new venditabant.users.login.ForgotWindow ( );
                forgot.show  ( );
                this.destroy ( );
            },
            _createLBL : function(txt) {
                let font = new qx.bom.Font ( 14, [ "Arial" ] );

                let lbl = new qx.ui.basic.Label ( "<b style='color: #FFFFFF'>" + txt + "</b>" );
                lbl.setFont ( font );
                lbl.setRich ( true );
                lbl.setWidth( 130 );

                return lbl;
            },
            login : function ( )  {
                let that = this;
                var name = this._name.getValue ( );
                var pass = this._pass.getValue ( );
                var remember = this._remember.getValue ( );
                if ( name.length < 1 || pass.length < 1 )  {
                    alert ( this.tr ( "Please provide username and password" ) );
                    return;
                }

                let app = new venditabant.communication.Post ( );
                let data = {
                    username:name, password:pass
                };
                app.send ( this._address, "/api/login/", data, function ( success, rsp ) {
                    if (success) {
                        loadWindow(rsp.data).then(function(data){
                            let support = false;
                            if(rsp.data.support === 1) {
                                support = true;
                            }
                            let win = new venditabant.application.ApplicationWindow();
                            win.set({
                                support:support
                            });
                            win.show();
                            that.destroy();
                        });
                            /*let jwt = new qx.data.store.Offline('userid','local');
                            jwt.setModel(qx.data.marshal.Json.createModel(rsp.data));*/


                    } else {
                        alert(this.tr("Could not log in."));
                    }
                }, this );

            },
            signup : function ( )  {
                var signup = new venditabant.users.login.SignupWindow ( );
                signup.show  ( );
                this.destroy ( );
            },
        }
    } );
