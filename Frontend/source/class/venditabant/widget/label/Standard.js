qx.Class.define("venditabant.widget.label.Standard",
    {
        extend: qx.core.Object,
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            createLbl : function (placeholder, width, required, requiredTxt) {
                let lbl = new qx.ui.basic.Label ( placeholder );
                lbl.setRich ( true );
                lbl.setWidth( width );
                return lbl;
            },
        }
    });