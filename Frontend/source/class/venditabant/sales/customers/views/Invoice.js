qx.Class.define ( "venditabant.settings.views.ProdGrpBox",
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
                let box1 = new qx.ui.groupbox.GroupBox(this.tr("Invoice Address"), null);
                box1.setLayout(new qx.ui.layout.VBox());
                let container = new qx.ui.container.Composite(new qx.ui.layout.HBox(6));

                let lbl = this._createLbl(this.tr( "Street" ),90);
                let prdgrp_txt = this._createTxt(
                    this.tr( "Address" ),100,false,''
                );
                this._prdgrp_txt = prdgrp_txt;
                prdgrp_txt.addListener("input",function(e){
                    let value = e.getData();
                },this);
                container.add(lbl,{flex:1});
                container.add(prdgrp_txt);
                box1.add(container);

                let prdgrp_desc = this._createTxt(
                    this.tr( "Description" ),120,true,this.tr("Product group is required")
                );
                this._prdgrp_desc = prdgrp_desc;
                box1.add(prdgrp_desc);
                let save_PRDGRP = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 120, function ( ) {
                    this.save_PRDGRP ( );
                }, this );
                box1.add(save_PRDGRP);

                var oneList = new qx.ui.form.List();
                oneList.addListener("changeSelection",function(e) {
                    let selection = e.getData()[0].getLabel();
                    let prdgrp_txt = selection.substring(0,selection.indexOf(' '));
                    let prdgrp_desc = selection.substring(selection.indexOf(' '));

                    this._prdgrp_txt.setValue(prdgrp_txt);
                    this._prdgrp_desc.setValue(prdgrp_desc);

                },this)

                oneList.set({ height: 100, width: 200, selectionMode : "one" });
                let get = new venditabant.settings.models.Settings();
                get.loadList(function(response) {
                    var item;
                    for (let i=0; i < response.data.length; i++) {
                        let row = response.data[i].param_value + ' ' + response.data[i].param_description;
                        item = new qx.ui.form.ListItem(row, null);
                        oneList.add(item);
                    }
                },this,'PRODUCTGROUPS');

                box1.add(oneList);

                return box1;
            }
        }
    });