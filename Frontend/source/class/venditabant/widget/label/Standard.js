qx.Class.define("venditabant.widget.label.Standard",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            createLbl : function (placeholder, width, tooltipTxt) {
                let lbl = new qx.ui.basic.Label ( placeholder );
                lbl.setRich ( true );
                lbl.setWidth( width );
                if(typeof tooltipTxt !== 'undefined' && tooltipTxt !== null) {
                    lbl.setToolTipText(tooltipTxt);
                }
                return lbl;
            },
        }
    });