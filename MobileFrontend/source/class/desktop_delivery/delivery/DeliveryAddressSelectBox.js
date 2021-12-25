
qx.Class.define("desktop_delivery.delivery.DeliveryAddressSelectBox",
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
        },
        members: {
            _selectbox:null,
            getView: function () {
                let selectbox = new qx.ui.form.SelectBox();
                selectbox.setWidth(this.getWidth());
                selectbox.addListener("changeSelection", function (e) {
                    if(typeof e.getData()[0] !== 'undefined') {
                        this._model = e.getData()[0];
                        if(this._model.getModel() !== null) {
                            this.getDelivery().setCustomerAddressModel(this._model.getModel());
                            this.getDelivery().loadSalesorderKey();
                            this.getDelivery().loadStockitemList();
                        }
                    }
                }, this);
                new desktop_delivery.helpers.LoadList().set({
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
            setKey:function(key) {
                new desktop_delivery.helpers.LoadList().set({
                    list: this._selectbox,
                    emptyrow: this.isEmptyrow(),
                    key:true,
                }).loadList(key);
            },
            setSelectedModel:function(value) {
                new desktop_delivery.helpers.LoadList().set({
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