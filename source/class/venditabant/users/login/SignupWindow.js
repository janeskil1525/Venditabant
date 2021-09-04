
qx.Class.define("venditabant.users.login.SignupWindow",
    {
        extend:qx.ui.container.Composite,

        construct : function() {
            this.base (arguments);
            this.setLayout(new qx.ui.layout.Canvas);
            this.set({ width: 300, height: 200 });
            this._buildSignup ( );
            var top  = parseInt ( ( qx.bom.Document.getHeight ( ) - 200 ) / 2, 10 );
            var left = parseInt ( ( qx.bom.Document.getWidth  ( ) - 300 ) / 2, 10 );
            var app  = qx.core.Init.getApplication ( );
            var root = app.getRoot( );
            root.add ( this, { top: top, left: left } );
        },
        destruct : function() {

        },
        members : {
            signup : function () {
                var name = this._name.getValue  ( );
                var pass1= this._pass1.getValue ( );
                var pass2= this._pass2.getValue ( );
                var email= this._email.getValue ( );
                if ( name.length < 1 || email.length < 1 || pass1.length < 1 )  {
                    alert ( this.tr ( "Please provide username, password, and email" ) );
                    return;
                }
                if ( pass1 !== pass2 )  {
                    alert ( this.tr ( "Passwords do not match." ) );
                    return;
                }

                var str = "type=signup";
                str += "&username="+name;
                str += "&password="+pass1;
                str += "&email="+email;
                var app = qx.core.Init.getApplication ( );
                app.rpc ( str, function ( success ) {
                    var win = null;
                    if ( success )  {
                        this.login ( );
                    }
                    else  {
                        alert ( this.tr ( "Could not signup." ) );
                    }
                }, this );
            },
            login : function () {
                let login = new venditabant.users.login.LoginWindow();
                login.show();
                this.destroy();
            },
            setBGColor : function (btn, clr1, clr2) {
                let elem = btn.getContentElement();
                let dom = elem.getDomElement();
                let img = "linear-gradient(" + clr1 + " 35%" + clr2 + " 100%)";
                if( dom.style.setProperty ) {
                    dom.style.setProperty("background-image",img, null);
                } else {
                    dom.style.setProperty("backgroundImage",img);
                }
            },
            _createBtn : function (txt, clr, width, cb, ctx) {
                let btn = new qx.ui.form.Button ( "<b style='color: white'>" + txt + "</b>" );
                btn.set ( { width: width, cursor: 'pointer' } );
                let lbl = btn.getChildControl ( "label" );
                lbl.setRich ( true );
                btn.addListenerOnce ( "appear", function ( )  {
                    this.setBGColor ( btn, "#AAAAAA00", "#AAAAAA00" );
                },this );
                btn.addListener ( "mouseover", function ( )  {
                    this.setBGColor ( btn, clr, clr );
                },this );
                btn.addListener ( "mouseout", function ( )  {
                    this.setBGColor ( btn, "#AAAAAA00", "#AAAAAA00" );
                },this );
                btn.addListener ( "execute", function ( e )  {
                    cb.call ( this );
                }, ctx );
                return btn;
            },
            _buildSignup : function () {
                let semi = new qx.ui.core.Widget ( );
                semi.set ( { opacity: 0.6, backgroundColor: "#404040" } );
                this.add ( semi, { top: 1, left: 1, right: 1, bottom: 1 } );

                let font = new qx.bom.Font ( 24, [ "Arial" ] );
                font.setBold ( true );
                let lbl = new qx.ui.basic.Label ( "<center><b style='color: #FFFFFF'>" + this.tr ( "Sign Up" ) + "</b></center>" );
                lbl.setFont ( font );
                lbl.setRich ( true );
                lbl.setWidth( this.getWidth ( ) - 20  );
                this.add ( lbl, { top: 10, left: 10 } );

                let line = new qx.ui.core.Widget ( );
                line.set ( { height: 2, backgroundColor: '#FFFFFF' } );
                this.add ( line, { top: 50, left: 10, right: 10 } );

                let name = new qx.ui.form.TextField ( );
                name.setPlaceholder ( this.tr ( "Username" ) );
                this.add ( name, { top: 65, left: 10, right: 10 } );
                this._name = name;

                let pass1 = new qx.ui.form.PasswordField ( );
                pass1.setPlaceholder ( this.tr ( "Password" ) );
                pass1.setWidth ( 135 );
                this.add ( pass1, { top: 100, left: 10 } );
                this._pass1 = pass1;

                let pass2 = new qx.ui.form.PasswordField ( );
                pass2.setPlaceholder ( this.tr ( "Retype Password" ) );
                pass2.setWidth ( 135 );
                this.add ( pass2, { top: 100, right: 10 } );
                this._pass2 = pass2;

                let email = new qx.ui.form.TextField ( );
                email.setPlaceholder ( this.tr ( "email" ) );
                email.setWidth ( 135 );
                this.add ( email, { top: 135, right: 10, left: 10 } );
                this._email = email;

                let btnSignup = this._createBtn ( this.tr ( "Sign Up" ), "#AAFFAA70", 135, function ( ) {
                    this.signup ( );
                }, this );
                this.add ( btnSignup, { bottom: 10, left: 10 } );

                let btnCancel = this._createBtn ( this.tr ( "Cancel" ), "#FFAAAA70", 135, function ( ) {
                    this.login ( );
                }, this );
                this.add ( btnCancel, { bottom: 10, right: 10 } );
            }

        }
    })
