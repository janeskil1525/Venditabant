
qx.Class.define("venditabant.company.views.CompaniesSelectBox",
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
            tooltip: {nullable:true, check:"String"},
        },
        members: {
            _selectbox:null,
            getView: function () {
                let selectbox = new qx.ui.form.SelectBox();
                selectbox.setWidth(this.getWidth());
                if (this.getTooltip()) {
                    selectbox.setToolTipText(this.getTooltip());
                }
                selectbox.addListener("changeSelection", function (e) {
                    this._model = e.getData()[0];
                }, this);

                new venditabant.company.helpers.CompaniesList().set({
                    list: selectbox,
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
                    return this._model.getModel().companies_pkey ? this._model.getModel().companies_pkey : 0;
                }
            },
            setSelectedModel:function(value) {
                new venditabant.company.helpers.CompaniesList().set({
                    list: this._selectbox,
                    emptyrow: this.isEmptyrow(),
                    key:false,
                }).loadList(value);
            },
            setKey:function(key) {
                new venditabant.company.helpers.CompaniesList().set({
                    list: this._selectbox,
                    emptyrow: this.isEmptyrow(),
                    key:true,
                }).loadList(key);
            }

        }
    });