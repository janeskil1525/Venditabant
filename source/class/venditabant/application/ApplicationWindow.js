qx.Class.define ( "venditabant.application.ApplicationWindow",
    {
        extend : qx.ui.window.Window,

        construct : function ( ) {
            this.base ( arguments );
            this.setLayout ( new qx.ui.layout.Canvas ( ) );
            this.setWidth  ( 400 );
            this.setHeight ( 250 );
            this._buildWindow  ( );
            var app  = qx.core.Init.getApplication ( );
            var root = app.getRoot ( );
            root.add ( this, { top: 10, left: 10 } );
        },
        destruct : function ( )  {
        },

        members  :  {
            // Public functions ...
            setParams : function ( params )  {
            },

            start : function ( )  {
                // virtual function to kick off exection.
                this.show ( );
            },
            logout : function ( )  {
                var str = "type=logout";
                var app = qx.core.Init.getApplication ( );
                app.rpc ( str, function ( success ) {
                    if ( success )  {
                        let win = new venditabant.users.login.LoginWindow ( );
                        win.show ( );
                        this.destroy ( );
                    }
                    else  {
                        alert ( this.tr ( "Could not log out." ) );
                    }
                }, this );
            },
            _buildWindow : function ( )  {
                var font = new qx.bom.Font ( 24, [ "Arial" ] );
                font.setBold ( true );
                var lbl = new qx.ui.basic.Label ( this.tr ( "Hello World" ) );
                lbl.setFont ( font );
                this.add ( lbl, { top: "50%", left: "40%" } );

                var btn = new qx.ui.form.Button ( this.tr ( "Logout" ) );
                btn.setWidth ( 90 );
                btn.addListener ( "execute", function ( e )  {
                    this.logout ( );
                }, this );
                this.add ( btn, { bottom: 5, right: 100 } );
                btn = new qx.ui.form.Button ( this.tr ( "Cancel" ) );
                btn.setWidth ( 90 );
                btn.addListener ( "execute", function ( e )  {
                    alert ( "Don't close me ... Please ..." );
//         this.close ( );
                }, this );
                this.add ( btn, { bottom: 5, right: 5 } );
            }
        }
    } );
