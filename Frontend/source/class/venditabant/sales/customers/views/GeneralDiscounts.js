

qx.Class.define ( "venditabant.sales.customers.views.GeneralDiscounts",
    {
            extend: venditabant.application.base.views.Base,
            include: [qx.locale.MTranslation],
            construct: function () {
            },
            destruct: function () {
            },
            properties: {
                    support: {nullable: true, check: "Boolean"}
            },
            members: {
                    // Public functions ...
                    getView: function () {
                        let box1 = new qx.ui.groupbox.GroupBox(this.tr("General"), null);
                        box1.setLayout(new qx.ui.layout.VBox());

                       let container = new qx.ui.container.Composite(new qx.ui.layout.HBox(6));

                        let lbl = this._createLbl(this.tr( "Sum" ),90);
                        let sum_txt = this._createTxt(
                            this.tr( "Discount" ),100,true,
                            this.tr("Dicount is required"),
                            this.tr("Either amount or percentage ended with %")
                        );
                        this._sum_txt = sum_txt;
                        sum_txt.addListener("input",function(e){
                            let value = e.getData();
                        },this);
                        container.add(lbl,{flex:1});
                        container.add(sum_txt);
                        box1.add(container);

                        let container2 = new qx.ui.container.Composite(new qx.ui.layout.HBox(6));

                        lbl = this._createLbl(this.tr( "Discount" ),90);
                        let invoicedays_txt = this._createTxt(
                            this.tr( "Discount" ),100,true,
                            this.tr("Dicount is required"),
                            this.tr("Either amount or percentage ended with %")
                        );
                        this._invoicedays_txt = invoicedays_txt;
                        invoicedays_txt.addListener("input",function(e){
                            let value = e.getData();
                        },this);
                        container2.add(lbl,{flex:1});
                        container2.add(invoicedays_txt);
                        box1.add(container2);

                        //box1.add(invoicedays_desc);
                        let save_invoicedays = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 120, function ( ) {
                            this.save_invoicedays ( );
                        }, this );
                        box1.add(save_invoicedays);

                        var oneList = new qx.ui.form.List();
                        oneList.addListener("changeSelection",function(e) {
                            let selection = e.getData()[0].getLabel();
                            let invoicedays_txt = selection.substring(0,selection.indexOf(' '));
                            //let invoicedays_desc = selection.substring(selection.indexOf(' '));

                            this._invoicedays_txt.setValue(invoicedays_txt);
                            //this._invoicedays_desc.setValue(invoicedays_desc);

                        },this);

                        oneList.set({ height: 100, width: 200, selectionMode : "one" });
                        /* let get = new venditabant.settings.models.Settings();
                        get.loadList(function(response) {
                            var item;
                            for (let i=0; i < response.data.length; i++) {
                                let row = response.data[i].param_value + ' ' + response.data[i].param_description;
                                item = new qx.ui.form.ListItem(row, null);
                                oneList.add(item);
                            }
                        },this,'INVOICEDAYS');*/

                        box1.add(oneList);

                        return box1;
                    },
            }
    });