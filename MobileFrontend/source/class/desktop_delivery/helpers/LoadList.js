qx.Class.define("desktop_delivery.helpers.LoadList",
    {
        extend: qx.core.Object,
        include: [qx.locale.MTranslation],
        construct: function () {

        },
        destruct: function () {

        },
        properties: {
            list: {nullable: true},
            emptyrow: {nullable: true, check: "Boolean"},
            customers_fkey: {nullable: true, check:"Number"},
            key:{nullable: true, check: "Boolean"},
        },
        members: {
            loadList: function (selected_value) {
                let get = new desktop_delivery.models.Deliveryaddresses();
                this._model = null;
                get.loadListDeliveryAddressListFromCompany(function(response) {
                    var item;
                    if(this.isEmptyrow()) {
                        item = new qx.ui.form.ListItem('', null, null);
                        this.getList().add(item);
                    }
                    if(response.data !== null) {
                        this.getList().removeAll();
                        if(this.isEmptyrow()) {
                            item = new qx.ui.form.ListItem('', null, null);
                            this.getList().add(item);
                        }
                        for (let i=0; i < response.data.length; i++) {
                            let row = response.data[i].name;
                            item = new qx.ui.form.ListItem(row, null, response.data[i]);
                            this.getList().add(item);
                            if (this.isKey() === true) {
                                if (selected_value === response.data[i].customer_addresses_pkey) {
                                    this.getList().setSelection([item])
                                }
                            } else {
                                if (selected_value === response.data[i].name) {
                                    this.getList().setSelection([item])
                                }
                            }
                        }
                    } else {
                        this.getList().removeAll();
                    }
                },this);
            }
        }
    });