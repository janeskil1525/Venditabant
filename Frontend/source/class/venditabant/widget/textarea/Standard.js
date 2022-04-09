

qx.Class.define("venditabant.widget.textarea.Standard",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            createTxt : function (placeholder, width, height, tooltipTxt) {
                var txt = new qx.ui.form.TextArea ( );
                txt.setPlaceholder ( placeholder );
                txt.setWidth( width );
                if (height > 0) {
                    txt.setHeight( height );
                }
                if(typeof tooltipTxt !== 'undefined' && tooltipTxt !== null && tooltipTxt !== '') {
                    txt.setToolTipText(tooltipTxt);
                }
                return txt;
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