
qx.Class.define("venditabant.support.views.MailTemplatesSelectBox",
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
            callback:{nullable: true},
        },
        members: {
            _selectbox:null,
            getView: function () {
                let selectbox = new qx.ui.form.SelectBox();
                selectbox.setWidth(this.getWidth());
                selectbox.addListener("changeSelection", function (e) {
                    this._model = e.getData()[0];
                    if(e.getData()[0].getModel() !== null) {
                        this.getCallback()._default_mailer_mails_pkey = 0;
                        this.getCallback().loadTemplates(e.getData()[0].getModel().mailer_pkey);
                    }
                }, this);

                new venditabant.support.helpers.MailTemplatesList().set({
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
                    return this._model.getModel().mailer_pkey ? this._model.getModel().mailer_pkey : 0;
                }
            },
            setSelectedModel:function(value) {
                new venditabant.support.helpers.MailTemplatesList().set({
                    list: this._selectbox,
                    emptyrow: this.isEmptyrow(),
                    key:false,
                }).loadList(value);
            },
            setKey:function(key) {
                new venditabant.support.helpers.MailTemplatesList().set({
                    list: this._selectbox,
                    emptyrow: this.isEmptyrow(),
                    key:true,
                }).loadList(key);
            }

        }
    });