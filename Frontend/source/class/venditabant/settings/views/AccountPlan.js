qx.Class.define ( "venditabant.settings.views.AccountPlan",
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
                        let box1 = new qx.ui.groupbox.GroupBox(this.tr("Account plan"), null);
                        box1.setLayout(new qx.ui.layout.VBox());
                        let container = new qx.ui.container.Composite(new qx.ui.layout.HBox(6));

                        let lbl = this._createLbl(this.tr( "Account" ),90);
                        let account_txt = this._createTxt(
                            this.tr( "Account" ),100,true,this.tr("Account is required")
                        );
                        this._account_txt = account_txt;

                        container.add(lbl,{flex:1});
                        container.add(account_txt);
                        box1.add(container);

                        let account_desc = this._createTxt(
                            this.tr( "Description" ),120,true,this.tr("Account description is required")
                        );
                        this._paccount_desc = account_desc;
                        box1.add(account_desc);
                        let save_account = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 120, function ( ) {
                            this.save_account ( );
                        }, this );
                        box1.add(save_account);

                        var oneList = new qx.ui.form.List();
                        oneList.addListener("changeSelection",function(e) {
                            let selection = e.getData()[0].getLabel();
                            let account_txt = selection.substring(0,selection.indexOf(' '));
                            let prdgrp_desc = selection.substring(selection.indexOf(' '));

                            this._account_txt.setValue(account_txt);
                            this._account_desc.setValue(account_desc);

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
                        },this,'ACCOUNTS');

                        box1.add(oneList);

                        return box1;
                    }
            }
    });