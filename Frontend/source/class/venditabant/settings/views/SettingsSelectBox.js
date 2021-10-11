qx.Class.define("venditabant.settings.views.SettingsSelectBox",
    {
        extend: qx.core.Object,
        include: [qx.locale.MTranslation],
        construct: function () {

        },
        destruct: function () {

        },
            properties: {
                    width: {nullable: true, check: "Number"},
                    parameter: {nullable:true, check:"String"},
                    emptyrow: {nullable: true, check: "Boolean"},
            },
        members: {
                _selectbox:null,
                getView: function () {
                        let selectbox = new qx.ui.form.SelectBox();
                        selectbox.setWidth(this.getWidth());
                        selectbox.addListener("changeSelection", function (e) {
                                this._model = e.getData()[0];
                        }, this);
                        new venditabant.settings.helpers.LoadList().set({
                                list: selectbox,
                                parameter: this.getParameter(),
                                emptyrow: this.isEmptyrow(),
                        }).loadList('');
                        this._selectbox = selectbox;
                        return selectbox;
                },
                getModel: function () {
                        return this._model;
                },
                getKey:function() {
                        if(this._model.getModel() === null) {
                                return 0;
                        } else {
                                return this._model.getModel().parameters_items_pkey ? this._model.getModel().parameters_items_pkey : 0;
                        }
                },
                setSelectedModel:function(value) {
                        let listitems = new qx.data.Array();
                        new venditabant.settings.helpers.LoadList().set({
                                list: this._selectbox,
                                parameter: this.getParameter(),
                                emptyrow: this.isEmptyrow(),
                        }).loadList(value);
                }

        }
    });