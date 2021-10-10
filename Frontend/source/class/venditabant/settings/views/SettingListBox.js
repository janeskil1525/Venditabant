qx.Class.define ( "venditabant.settings.views.SettingListBox",
    {
            extend: venditabant.application.base.views.Base,
            include: [qx.locale.MTranslation],
            construct: function () {
            },
            destruct: function () {
            },
            properties: {
                support: {nullable: true, check: "Boolean"},
                width: {nullable:true, check:"Number"},
                height: {nullable:true, check:"Number"},
                savebuttonwidth: {nullable:true, check:"Number"},
                parameter: {nullable:true, check:"String"},
                groupboxheader: {nullable:true, check:"String"},
                valuelabel: {nullable:true, check:"String"},
                valueplaceholder: {nullable:true, check:"String"},
                invalidmessage: {nullable:true, check:"String"},
                descriptionplaceholder: {nullable:true, check:"String"},
                descriptioninvalidmessage: {nullable:true, check:"String"},
                valuefilter: {nullable:true},
                savebutton: {nullable:true, check:"String"},
                deletebutton: {nullable:true, check:"String"},
                newbutton: {nullable:true, check:"String"},
                emptyrow:{nullable: true, check: "Boolean"},
            },
            members: {
                    // Public functions ...
                    getView: function () {
                        let box1 = new qx.ui.groupbox.GroupBox(this.getGroupboxheader(), null);
                        box1.setLayout(new qx.ui.layout.VBox());
                        let container_param_value = new qx.ui.container.Composite(new qx.ui.layout.HBox(6));

                        let lbl = this._createLbl(this.getValuelabel(),90);
                        let param_value = this._createTxt(
                            this.getValueplaceholder(),100,true,this.getInvalidmessage()
                        );
                        if(this.getValuefilter() !== null) {
                            param_value.setFilter(this.getValuefilter());
                        }
                        this._param_value = param_value;

                        container_param_value.add(lbl,{flex:1});
                        container_param_value.add(param_value);
                        container_param_value.setPaddingBottom(5)
                        box1.add(container_param_value);

                        let param_description = this._createTxt(
                            this.getDescriptionplaceholder(),120,true,this.getDescriptioninvalidmessage()
                        );
                        this._param_description = param_description;
                        param_description.setPaddingBottom(5);
                        let container_param_description = new qx.ui.container.Composite(new qx.ui.layout.VBox());
                        container_param_description.add(param_description,{flex:1})
                        container_param_description.setPaddingBottom(5)
                        box1.add(container_param_description);

                        let save_param = this._createBtn ( this.getSavebutton(), "rgba(239,180,255,0.44)", this.getSavebuttonwidth(), function ( ) {
                            this.savePrameter();
                        }, this );

                        let new_param = this._createBtn ( this.getNewbutton(), "rgba(239,180,255,0.44)", this.getSavebuttonwidth(), function ( ) {
                            this._param_value.setValue('');
                            this._param_description.setValue('');
                            this._model = null;
                        }, this );

                        let delete_param = this._createBtn ( this.getDeletebutton(), "rgba(239,180,255,0.44)", this.getSavebuttonwidth(), function ( ) {
                            this.deleteParameter();
                        }, this );

                        let save_layout = new qx.ui.layout.HBox();
                        save_layout.setSpacing(4);
                        let container_save_param = new qx.ui.container.Composite(save_layout);
                        container_save_param.add(save_param,{flex:1});
                        container_save_param.add(new_param,{flex:1});
                        container_save_param.add(delete_param,{flex:1});
                        container_save_param.setPaddingBottom(5)

                        box1.add(container_save_param);

                        var oneList = new qx.ui.form.List();
                        oneList.addListener("changeSelection",function(e) {
                            if(typeof e.getData()[0] !== 'undefined') {
                                let selection = e.getData()[0].getLabel();
                                let param_value = selection.substring(0,selection.indexOf(' ')).trim();
                                let param_description = selection.substring(selection.indexOf(' ')).trim();
                                this._param_value.setValue(param_value);
                                this._param_description.setValue(param_description);
                                this._model = e.getData()[0].getModel();
                            }
                        },this)

                        oneList.set(
                            { height: this.getHeight(),
                                width: this.getWidth(),
                                selectionMode : "one"
                            });

                        this._oneList = oneList;
                        this.loadList();
                        box1.add(oneList);

                        return box1;
                    },
                deleteParameter:function() {
                    let that = this;
                    let parameters_items_pkey = 0;
                    if(this._model !== null) {
                        parameters_items_pkey = this._model.parameters_items_pkey;
                    }

                    if(parameters_items_pkey > 0) {
                        let data = {
                            parameters_items_pkey: parameters_items_pkey
                        }
                        let del = new venditabant.settings.models.Settings();
                        del.deleteSetting(data,function(success) {
                            that.loadList();
                        }, this);
                    }
                },
                loadList:function() {
                    new venditabant.settings.helpers.LoadList().set({
                        list: this._oneList,
                        parameter: this.getParameter(),
                        emptyrow:this.isEmptyrow()
                    }).loadList();
                },
                savePrameter:function() {

                    let that = this;
                    let parameters_items_pkey = 0;
                    if(typeof this._model !== 'undefined' && this._model !== null) {
                        parameters_items_pkey = this._model.parameters_items_pkey;
                    }

                    let data = {
                        param_value: this._param_value.getValue(),
                        param_description: this._param_description.getValue(),
                        parameter:this.getParameter(),
                        parameters_items_pkey: parameters_items_pkey
                    }
                    let save = new venditabant.settings.models.Settings();
                    save.saveSetting(data,function(success){
                        if (success) {
                            that.loadList();
                        }
                    });
                }
            }
    });