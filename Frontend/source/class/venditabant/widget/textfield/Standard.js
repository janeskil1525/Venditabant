qx.Class.define("venditabant.widget.textfield.Standard",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            createTxt : function (placeholder, width, required, requiredTxt, tooltipTxt) {
                var txt = new qx.ui.form.TextField ( );
                txt.setPlaceholder ( placeholder );
                txt.setWidth( width );
                if(typeof required !== 'undefined') {
                    txt.setRequired(required);
                    if(typeof requiredTxt !== 'undefined') {
                        txt.setRequiredInvalidMessage(requiredTxt);
                    }
                }
                if(typeof tooltipTxt !== 'undefined' && tooltipTxt !== null) {
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