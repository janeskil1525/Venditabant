qx.Class.define("venditabant.sales.pricelists.helpers.LoadList",
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
        },
        members: {
            loadList: function (selected_value) {
                let get = new venditabant.sales.pricelists.models.Pricelists();
                this._model = null;
                get.loadList(function(response) {
                    var item;
                    if(response.data !== null) {
                        this.getList().removeAll();
                        if(this.isEmptyrow()) {
                            item = new qx.ui.form.ListItem('', null, null);
                            this.getList().add(item);
                        }
                        for (let i=0; i < response.data.length; i++) {
                            let row = response.data[i].pricelist;
                            item = new qx.ui.form.ListItem(row, null, response.data[i]);
                            this.getList().add(item);
                            if(selected_value === response.data[i].pricelist){
                                this.getList().setSelection([item])
                            }
                        }
                    }
                },this);
            }
        }
    });