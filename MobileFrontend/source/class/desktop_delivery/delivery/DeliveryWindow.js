qx.Class.define ( "desktop_delivery.delivery.DeliveryWindow",
    {
        extend: qx.ui.container.Composite,
        construct: function () {
            this.base(arguments);
            this.setLayout(new qx.ui.layout.Canvas());
            this.set({width: 300, height: 200});
            this._buildDeliveryWindow();

            var top = parseInt((qx.bom.Document.getHeight() - 200) / 2, 10);
            var left = parseInt((qx.bom.Document.getWidth() - 300) / 2, 10);
            var app = qx.core.Init.getApplication();
            var root = app.getRoot();
            root.add(this, {top: top, left: left});
        },
        destruct : function ( )  {

        },
        members  : {
            _buildDeliveryWindow:function() {
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
            }

        }
    });