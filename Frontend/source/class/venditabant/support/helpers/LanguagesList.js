
qx.Class.define("venditabant.support.helpers.LanguagesList",
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
                let get = new venditabant.support.models.Languages();
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
                            let row = response.data[i].lan + ' ' + response.data[i].lan_name;
                            item = new qx.ui.form.ListItem(row, null, response.data[i]);
                            this.getList().add(item);
                            if(this.isKey() === true) {
                                if(selected_value === response.data[i].languages_pkey){
                                    this.getList().setSelection([item])
                                }
                            } else {
                                if(selected_value === response.data[i].lan){
                                    this.getList().setSelection([item])
                                }
                            }
                        }
                    }
                },this);
            }
        }
    });