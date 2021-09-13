
qx.Class.define ( "venditabant.sales.pricelists.views.NewHead",
    {
        extend: qx.ui.window.Window,

        construct: function (cb) {
            this.__cb = cb;
            this.base(arguments);
            this.setLayout(new qx.ui.layout.Canvas());
            this.setWidth(1000);
            this.setHeight(1000);
            this._buildWindow();
            var app = qx.core.Init.getApplication();
            var root = app.getRoot();
            root.add(this, {top: 10, left: 10});

        },
        destruct: function () {
        },

        members: {
            // Public functions ...
            __table: null,
            __cb:null,
            setParams: function (params) {
            },
            _buildWindow: function () {
                var win = new qx.ui.window.Window("Pricelists", "icon/16/apps/internet-feed-reader.png");
                win.setLayout(new qx.ui.layout.Canvas());
                win.setStatus("Application is ready");
                win.setWidth(630);
                win.setHeight(200);
                win.setCenterOnAppear(true);
                win.open();
                let app = qx.core.Init.getApplication();
                let root = app.getRoot();
                root.add(win, {left: 350, top: 120});

                var atom = new qx.ui.basic.Atom("New pricelist", "icon/22/apps/utilities-calculator.png");
                win.add(atom);
                win.setShowStatusbar(true);

                /*var box = new qx.ui.container.Composite();
                box.setLayout(new qx.ui.layout.HBox(10));
                win.add(box, {flex: 1});*/


                let lbl = new qx.ui.basic.Label(this.tr("Price list"));
                lbl.setRich(true);
                lbl.setWidth(70);
                win.add(lbl, {top: 30, left: 10});

                var pricelist = new qx.ui.form.TextField();
                pricelist.setPlaceholder(("Price list"));
                pricelist.setWidth(150);

                win.add(pricelist, {top: 30, left: 90});
                this._pricelist = pricelist;

                lbl = new qx.ui.basic.Label(("Description"));
                lbl.setRich(true);
                lbl.setWidth(70);
                win.add(lbl, {top: 30, left: 250});

                var descriptn = new qx.ui.form.TextField();
                descriptn.setPlaceholder(("Description"));
                descriptn.setWidth(250);

                win.add(descriptn, {top: 30, left: 348});
                this._description = descriptn;

                let btnSignup = this._createBtn(this.tr("Save"), "rgba(239,170,255,0.44)", 135, function () {
                    this.addPricelist();
                }, this);
                win.add(btnSignup, {bottom: 10, left: 10});

                let btnCancel = this._createBtn(this.tr("Cancel"), "#FFAAAA70", 135, function () {
                    this.cancel();
                }, this);
                win.add(btnCancel, {bottom: 10, right: 10});
            },
            addPricelist: function () {
                let pricelist = this._pricelist.getValue();
                let description = this._description.getValue();
                let data = {
                    pricelist: pricelist,
                    description: description
                }
                let model = new venditabant.sales.pricelists.models.Pricelists();
                model.savePricelistHead(data, this.__cb,)

                alert("Add pricelist");
            },
            savePriceListHead: function () {
                let stockitem = this._stockitem.getValue();
                let description = this._description.getValue();
                let data = {
                    stockitem: stockitem,
                    description: description
                }
                let com = new venditabant.communication.Post();
                com.send("http://192.168.1.134/", "api/v1/stockitem/save/", data, function (success) {
                    let win = null;
                    if (success) {
                        this.loadStockitems();
                        alert("Saved item successfully");
                    } else {
                        alert(this.tr('success'));
                    }
                }, this);

            },
            _createBtn: function (txt, clr, width, cb, ctx) {
                let btn = new venditabant.widget.button.Standard().createBtn(txt, clr, width, cb, ctx)

                return btn;
            },
        }
    });
