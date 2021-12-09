
qx.Class.define("venditabant.support.views.PartSelectBox",
    {
        extend: qx.core.Object,
        include: [qx.locale.MTranslation],
        construct: function () {

        },
        destruct: function () {

        },
        properties: {
            width: {nullable: true, check: "Number"},
            emptyrow: {nullable: true, check: "Boolean"},
            callback:{nullable: true},
        },
        members: {
            _selectbox:null,
            getView: function () {
                let selectbox = new qx.ui.form.SelectBox();
                selectbox.setWidth(this.getWidth());
                selectbox.addListener("changeSelection", function (e) {
                    this._model = e.getData()[0].getModel();
                    this.getCallback().clearScreen();
                    this.getCallback().loadWorkflow();
                }, this);

                new venditabant.support.helpers.PartList().set({
                    list: selectbox,
                }).loadList('');
                this._selectbox = selectbox;
                return selectbox;
            },
            getModel: function () {
                return this._model;
            },
            getKey:function() {
                if(this._model.getModel() === null) {
                    return '';
                } else {
                    return this._model.getModel() ? this._model.getModel() : '';
                }
            },
            setSelectedModel:function(value) {
                new venditabant.support.helpers.PartList().set({
                    list: this._selectbox,
                }).loadList(value);
            },
        }
    });