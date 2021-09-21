qx.Class.define ( "venditabant.users.login.ForgotWindow",
    {
        extend : qx.ui.container.Composite,

        construct : function ( ) {
            this.base ( arguments );
            this.setLayout ( new qx.ui.layout.Canvas ( ) );
            this.set ( { width: 300, height: 200 } );
            this._buildSignup ( );
            var app  = qx.core.Init.getApplication ( );
            var root = app.getRoot( );
            var top  = parseInt ( ( qx.bom.Document.getHeight ( ) - 200 ) / 2, 10 );
            var left = parseInt ( ( qx.bom.Document.getWidth  ( ) - 300 ) / 2, 10 );
            root.add ( this, { top: top, left: left } );
        },
        destruct : function ( )  {
        },

        members  :  {
            submit : function ( )  {
                let email = this._email.getValue( );
                let name = this._name.getValue( );
                let pass = this._pass.getValue( );
                if ( name.length < 1 || email.length < 1 || pass.length < 1 )  {
                    alert ( this.tr ( "Please provide username, password, and email" ) );
                    return;
                }

                let str = "type=forgot";
                str += "&email="+email;
                let app = qx.core.Init.getApplication ( );
                app.rpc ( str, function ( success ) {
                    let win = null;
                    if ( success )  {
                        this.login ( );
                    }
                    else  {
                        alert ( this.tr ( "Could not signup." ) );
                    }
                }, this );
            },
            login : function ( )  {
                let login = new venditabant.users.login.LoginWindow ( );
                login.show  ( );
                this.destroy( );
            },
            setBGColor : function ( btn, clr1, clr2 ) {
                let elem = btn.getContentElement ( );
                let dom  = elem.getDomElement ( );
                let img  = "linear-gradient(" + clr1 + " 35%, " + clr2 + " 100%)";
                if ( dom.style.setProperty )
                    dom.style.setProperty ( "background-image", img, null );
                else
                    dom.style.setAttribute ( "backgroundImage", img );
            },
            _createBtn : function ( txt, clr, width, cb, ctx )  {
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
            _buildSignup : function ( )  {
                let semi = new qx.ui.core.Widget ( );
                semi.set ( { opacity: 0.6, backgroundColor: "#404040" } );
                this.add ( semi, { top: 1, left: 1, right: 1, bottom: 1 } );

                let font = new qx.bom.Font ( 24, [ "Arial" ] );
                font.setBold ( true );
                let lbl = new qx.ui.basic.Label ( "<center><b style='color: #FFFFFF'>" + this.tr ( "Forgot Password" ) + "</b></center>" );
                lbl.setFont ( font );
                lbl.setRich ( true );
                lbl.setWidth( this.getWidth ( ) - 20  );
                this.add ( lbl, { top: 10, left: 10 } );

                let line = new qx.ui.core.Widget ( );
                line.set ( { height: 2, backgroundColor: '#FFFFFF' } );
                this.add ( line, { top: 50, left: 10, right: 10 } );

                let txt = this.tr ( "Please provide your email address." );
                lbl = new qx.ui.basic.Label ( "<b style='color: #FFFFFF'>" + txt + "</b>" );
                lbl.setRich ( true );
                lbl.setWidth( this.getWidth ( ) - 20  );
                this.add ( lbl, { top: 60, left: 10 } );

                let email = new qx.ui.form.TextField ( );
                email.setPlaceholder ( this.tr ( "email" ) );
                email.setWidth ( 135 );
                this.add ( email, { top: 80, right: 10, left: 10 } );
                this._email = email;

                let btnSubmit = this._createBtn ( this.tr ( "Submit" ), "#AAFFAA70", 135, function ( ) {
                    this.submit ( );
                }, this );
                this.add ( btnSubmit, { bottom: 10, left: 10 } );

                let btnCancel = this._createBtn ( this.tr ( "Back" ), "#FFAAAA70", 135, function ( ) {
                    this.login ( );
                }, this );
                this.add ( btnCancel, { bottom: 10, right: 10 } );
            }
        }
    } );
