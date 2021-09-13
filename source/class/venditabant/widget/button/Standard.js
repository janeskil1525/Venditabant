qx.Class.define("venditabant.widget.button.Standard",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            createBtn : function (txt, clr, width, cb, ctx) {
                let btn = new qx.ui.form.Button (  txt  );
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
        }
    });