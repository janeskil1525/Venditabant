

qx.Class.define("venditabant.support.helpers.WorkflowsList",
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
                let get = new venditabant.support.models.Workflows();
                this._model = null;

                get.loadMailerList(function(response) {
                    var item;
                    if(response.data !== null) {
                        this.getList().removeAll();
                        if(this.isEmptyrow()) {
                            item = new qx.ui.form.ListItem('', null, null);
                            this.getList().add(item);
                        }
                        for (let i=0; i < response.data.length; i++) {
                            let row = response.data[i].workflow;
                            item = new qx.ui.form.ListItem(row, null, response.data[i]);
                            this.getList().add(item);
                            if(this.isKey() === true) {
                                if(selected_value === response.data[i].workflows_pkey){
                                    this.getList().setSelection([item])
                                }
                            } else {
                                if(selected_value === response.data[i].workflow){
                                    this.getList().setSelection([item])
                                }
                            }
                        }
                    }
                },this);
            }
        }
    });