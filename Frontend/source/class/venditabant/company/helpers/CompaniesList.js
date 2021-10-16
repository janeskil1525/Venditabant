qx.Class.define("venditabant.company.helpers.CompaniesList",
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
                let get = new venditabant.company.models.Company();
                this._model = null;
                get.loadList(function(response) {
                    var item;
                    if(this.isEmptyrow()) {
                        item = new qx.ui.form.ListItem('', null, null);
                        this.getList().add(item);
                    }
                    if(response.data !== null) {
                        this.getList().removeAll();
                        for (let i=0; i < response.data.length; i++) {
                            let row = response.data[i].company;
                            item = new qx.ui.form.ListItem(row, null, response.data[i]);
                            this.getList().add(item);
                            if (this.isKey() === true) {
                                if (selected_value === response.data[i].companies_pkey) {
                                    this.getList().setSelection([item])
                                }
                            } else {
                                if (selected_value === response.data[i].company) {
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