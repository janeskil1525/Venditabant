qx.Class.define ( "venditabant.application.base.views.Base",
    {
        extend: qx.core.Object,
        construct: function () {

        },
        destruct: function () {
        },
        members: {
            _createChkBox: function (txt, clr, width, cb, ctx) {
                let btn = new venditabant.widget.button.Standard().createChkBox(txt, clr, width, cb, ctx);
                return btn;
            },
            _createBtn: function (txt, clr, width, cb, ctx) {
                let btn = new venditabant.widget.button.Standard().createBtn(txt, clr, width, cb, ctx)
                return btn;
            },
            _createTxt: function (placeholder, width, required, requiredTxt) {
                let txt = new venditabant.widget.textfield.Standard().createTxt(placeholder, width, required, requiredTxt);
                return txt;
            },
            _createLbl: function (label, width, required, requiredTxt) {
                let lbl = new venditabant.widget.label.Standard().createLbl(label, width, required, requiredTxt);
                return lbl;
            },
            _createTextArea:function (placeholder, width, required, requiredTxt) {
                let txt = new venditabant.widget.textarea.Standard()
                let txtarea = txt.createTxt(placeholder, width, required, requiredTxt);
                return txtarea;
            },
        }
    });