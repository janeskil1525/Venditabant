
qx.Class.define("venditabant.sales.customers.views.DeliveryAddressSelectBox",
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
        },
        members: {
            _selectbox:null,
            getView: function () {
                let selectbox = new qx.ui.form.SelectBox();
                selectbox.setWidth(this.getWidth());
                selectbox.addListener("changeSelection", function (e) {
                    this._model = e.getData()[0];
                }, this);
                new venditabant.sales.customers.helpers.LoadList().set({
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
                    return this._model.getModel().customer_addresses_pkey ? this._model.getModel().customer_addresses_pkey : 0;
                }
            },
            setSelectedModel:function(value) {
                new venditabant.sales.customers.helpers.LoadList().set({
                    list: this._selectbox,
                    emptyrow: this.isEmptyrow(),
                }).loadList(value);
            }

        }
    });