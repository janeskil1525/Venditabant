

qx.Class.define("venditabant.support.helpers.PartList",
    {
        extend: qx.core.Object,
        include: [qx.locale.MTranslation],
        construct: function () {

        },
        destruct: function () {

        },
        properties: {
            list: {nullable: true},
        },
        members: {
            loadList: function (selected_value) {
                var item;
                let parts = ['action', 'condition', 'persister', 'validator', 'workflow'];
                this.getList().removeAll();
                for (let i=0; i < parts.length; i++) {
                    let row = parts[i];
                    item = new qx.ui.form.ListItem(row, null, parts[i]);
                    this.getList().add(item);
                    if(selected_value === parts[i]){
                        this.getList().setSelection([item])
                    }
                }
            }
        }
    });