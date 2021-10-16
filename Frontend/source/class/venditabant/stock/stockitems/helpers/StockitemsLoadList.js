

qx.Class.define("venditabant.stock.stockitems.helpers.StockitemsLoadList",
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
            key:{nullable: true, check: "Boolean"},
        },
        members: {
            loadList: function (selected_value) {
                let get = new venditabant.stock.stockitems.models.Stockitem();
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
                            let row = response.data[i].stockitem;
                            item = new qx.ui.form.ListItem(row, null, response.data[i]);
                            this.getList().add(item);
                            if(this.isKey() === true) {
                                if(selected_value === response.data[i].stockitems_pkey){
                                    this.getList().setSelection([item])
                                }
                            } else {
                                if(selected_value === response.data[i].stockitem){
                                    this.getList().setSelection([item])
                                }
                            }
                        }
                    }
                },this);
            }
        }
    });