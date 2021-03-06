qx.Class.define("venditabant.widget.button.Standard",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            createChkBox : function(txt, clr, width, cb, ctx, tooltipTxt) {
                let box = new qx.ui.form.CheckBox (  txt  );
                box.set ( { width: width, cursor: 'pointer' } );
                if(typeof tooltipTxt !== 'undefined' && tooltipTxt !== null) {
                    box.setToolTipText(tooltipTxt);
                }
                box.addListenerOnce ( "appear", function ( )  {
                    this.setBGColor ( box, "#AAAAAA00", "#AAAAAA00" );
                },this );
                box.addListener ( "mouseover", function ( )  {
                    this.setBGColor ( box, clr, clr );
                },this );
                box.addListener ( "mouseout", function ( )  {
                    this.setBGColor ( box, "#AAAAAA00", "#AAAAAA00" );
                },this );
                box.addListener ( "execute", function ( e )  {
                    cb.call ( this );
                }, ctx );
                return box;
            },
            createBtn : function (txt, clr, width, cb, ctx, tooltipTxt) {
                let btn = new qx.ui.form.Button (  txt  );
                btn.set ( { width: width, cursor: 'pointer' } );
                if(typeof tooltipTxt !== 'undefined' && tooltipTxt !== null) {
                    btn.setToolTipText(tooltipTxt);
                }
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