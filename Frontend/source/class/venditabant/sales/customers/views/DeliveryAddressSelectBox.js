
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
            delivery:{nullable: true},
            tooltip: {nullable:true, check:"String"},
        },
        members: {
            _selectbox:null,
            getView: function () {
                let selectbox = new qx.ui.form.SelectBox();
                if (this.getTooltip()) {
                    selectbox.setToolTipText(this.getTooltip());
                }
                selectbox.setWidth(this.getWidth());
                selectbox.addListener("changeSelection", function (e) {
                    if(typeof e.getData()[0] !== 'undefined') {
                        this._model = e.getData()[0];
                        if(this._model.getModel() !== null) {
                            this.getDelivery().setCustomerAddressFkey(this._model.getModel().customer_addresses_pkey)
                            this.getDelivery().loadDeliveryData();
                        }
                    }
                }, this);
                new venditabant.sales.customers.helpers.LoadList().set({
                    list: selectbox,
                    emptyrow: this.isEmptyrow(),
                    customers_fkey: this.getCustomersFkey(),
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
            setKey:function(key) {
                new venditabant.sales.customers.helpers.LoadList().set({
                    list: this._selectbox,
                    emptyrow: this.isEmptyrow(),
                    key:true,
                }).loadList(key);
            },
            setSelectedModel:function(value) {
                new venditabant.sales.customers.helpers.LoadList().set({
                    list: this._selectbox,
                    emptyrow: this.isEmptyrow(),
                    customers_fkey: this.getCustomersFkey(),
                    key:false,
                }).loadList(value);
            },
            setCustomersFkey:function(customers_fkey) {
                this._customers_fkey = customers_fkey;
                this.setSelectedModel('');
            },
            getCustomersFkey:function() {
                return this._customers_fkey ? this._customers_fkey : 0;
            },
        }
    });