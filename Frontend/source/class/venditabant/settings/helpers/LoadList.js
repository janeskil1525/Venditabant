qx.Class.define("venditabant.settings.helpers.LoadList",
    {
        extend: qx.core.Object,
        include: [qx.locale.MTranslation],
        construct: function () {

        },
        destruct: function () {

        },
        properties: {
            list: {nullable: true},
            parameter: {nullable:true, check:"String"},
            emptyrow: {nullable: true, check: "Boolean"},
        },
        members: {
            loadList: function (selected_value) {
                let get = new venditabant.settings.models.Settings();
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
                            let row = response.data[i].param_value + ' ' + response.data[i].param_description;
                            item = new qx.ui.form.ListItem(row, null, response.data[i]);
                            this.getList().add(item);
                            if(selected_value === response.data[i].param_value){
                                this.getList().setSelection([item])
                            }
                        }
                    }
                },this,this.getParameter());
            }
        }
    });